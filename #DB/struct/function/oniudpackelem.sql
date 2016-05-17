CREATE FUNCTION oniudpackelem() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltaold NUMERIC:=0;
 deltanew NUMERIC:=0;
 deltaoldfv NUMERIC:=0;
 deltanewfv NUMERIC:=0;
 packhead record;
 ilosc INT;
 zmiananaglowka BOOL:=false;
BEGIN

 IF (TG_OP<>'DELETE') THEN
  IF (TG_OP='UPDATE') THEN
   IF (NEW.pk_idpaczki<>OLD.pk_idpaczki) THEN
    ---zmiana naglowka paczki
    SELECT * INTO packhead FROM tg_packhead WHERE pk_idpaczki=OLD.pk_idpaczki;   
    IF ((packhead.pk_flaga&4)<>4) THEN
     RAISE EXCEPTION 'Nie mozna zmieniac naglowka paczki';
    END IF;
    SELECT * INTO packhead FROM tg_packhead WHERE pk_idpaczki=NEW.pk_idpaczki;
    IF ((packhead.pk_flaga&4)<>4) THEN
     RAISE EXCEPTION 'Nie mozna zmieniac naglowka paczki';
    END IF;
    zmiananaglowka=TRUE;
   ELSE ---update bez zmiany naglowka
    SELECT * INTO packhead FROM tg_packhead WHERE pk_idpaczki=NEW.pk_idpaczki;
   END IF;
  ELSE 
   SELECT * INTO packhead FROM tg_packhead WHERE pk_idpaczki=NEW.pk_idpaczki;
  END IF;
 ELSE
  SELECT * INTO packhead FROM tg_packhead WHERE pk_idpaczki=OLD.pk_idpaczki;
 END IF;

 IF (TG_OP='INSERT') THEN 
  IF (NEW.tel_idelem_fv>0 AND (packhead.pk_flaga&4)=4) THEN
  --pobieramy ilosc na paczke z pozycji
   NEW.pe_iloscf=(SELECT tel_iloscf FROM tg_transelem WHERE tel_idelem=NEW.tel_idelem_fv);
   RAISE NOTICE 'Mam ilosc % ',NEW.pe_iloscf;
  END IF;
 END IF;

 IF (TG_OP<>'INSERT') THEN
  IF (OLD.tel_idelem_fv IS NULL) THEN
   deltaold=deltaold-OLD.pe_iloscf;
  END IF;
  IF ((packhead.pk_flaga&4)=0) THEN ---tylko wowczas gdy nie ma sterowania iloscia przez dokument
   deltaoldfv=deltaoldfv-OLD.pe_iloscf;
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  IF (NEW.tel_idelem_fv IS NULL) THEN
   deltanew=deltanew+NEW.pe_iloscf;
  END IF;
  IF ((packhead.pk_flaga&4)=0) THEN ---tylko wowczas gdy nie ma sterowania iloscia przez dokument
   deltanewfv=deltanewfv+NEW.pe_iloscf;
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NEW.tel_idelem_pzam=OLD.tel_idelem_pzam) THEN
   deltanew=deltanew+deltaold;
   deltaold=0;
  END IF;
  IF (NEW.tel_idelem_fv=OLD.tel_idelem_fv) THEN
   deltanewfv=deltanewfv+deltaoldfv;
   deltaoldfv=0;
  END IF;
 END IF;

 IF (deltaold<>0) THEN
  UPDATE tg_zamilosci SET zmi_if_aviso=zmi_if_aviso+deltaold WHERE tel_idelem=OLD.tel_idelem_pzam;
 END IF;

 IF (deltanew<>0) THEN
  UPDATE tg_zamilosci SET zmi_if_aviso=zmi_if_aviso+deltanew WHERE tel_idelem=NEW.tel_idelem_pzam;
 END IF;

 IF (deltaoldfv<>0) THEN
  PERFORM checkTransElemChange(OLD.tel_idelem_fv);
  UPDATE tg_transelem SET tel_ilosc=tel_ilosc+round(1000*deltaoldfv/tel_przelnilosci,4) WHERE tel_idelem=OLD.tel_idelem_fv;
 END IF;

 IF (deltanewfv<>0) THEN
  PERFORM checkTransElemChange(NEW.tel_idelem_fv);
  UPDATE tg_transelem SET tel_ilosc=tel_ilosc+round(1000*deltanewfv/tel_przelnilosci,4) WHERE tel_idelem=NEW.tel_idelem_fv;
 END IF;

 IF (TG_OP='INSERT') THEN
  ---zaznaczamy na naglowku ze mamy pozycje
  UPDATE tg_packhead SET pk_flaga=pk_flaga|8 WHERE pk_idpaczki=NEW.pk_idpaczki;
 END IF;

 IF (TG_OP='UPDATE' AND zmiananaglowka) THEN
  ---zaznaczamy na nowym naglowku ze mamy pozycje a na starym ze zdejmujemy pozycje
  UPDATE tg_packhead SET pk_flaga=pk_flaga|8 WHERE pk_idpaczki=NEW.pk_idpaczki;
  ilosc=(SELECT count(*) FROM tg_packelem WHERE pk_idpaczki=OLD.pk_idpaczki);
  IF (ilosc<=1) THEN
   UPDATE tg_packhead SET pk_flaga=pk_flaga&(~8) WHERE pk_idpaczki=OLD.pk_idpaczki;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  ---usuwamy skojarzenie oznaczenie transelemu ze jest w paczce
  IF ((OLD.pe_flaga&2)=0) THEN
   UPDATE tg_transelem SET  tel_newflaga=tel_newflaga&(~((1<<18)+(1<<21))) WHERE tel_idelem=OLD.tel_idelem_fv;
  END IF;
  --sprawdzamy czy sa jakies pozycje oprocz naszej na paczce jesli tak to kasujemy paczke
  ilosc=(SELECT count(*) FROM tg_packelem WHERE pk_idpaczki=OLD.pk_idpaczki);
  IF (ilosc<=1) THEN
   UPDATE tg_packhead SET pk_flaga=pk_flaga&(~8) WHERE pk_idpaczki=OLD.pk_idpaczki;
  END IF;
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
