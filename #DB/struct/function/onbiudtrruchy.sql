CREATE FUNCTION onbiudtrruchy() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltate    v.delta;
 
 deltai_dysp v.delta;
 deltaic_dysp v.delta;
 
 flaga INT:=0;
 doteupdate BOOL:=false;
 
 _kwh_numer TEXT;
BEGIN
 
 IF (TG_OP<>'INSERT') THEN
  IF (OLD.dmag_iddyspozycji IS NOT NULL) THEN   
   deltai_dysp.value_old=OLD.kwc_ilosc;
   deltai_dysp.id_old=OLD.dmag_iddyspozycji;
  
   IF ((OLD.kwc_flaga&16)!=0) THEN
    deltaic_dysp.value_old=OLD.kwc_ilosc;
    deltaic_dysp.id_old=OLD.dmag_iddyspozycji;
   END IF;
  END IF;
  
   IF (OLD.tel_idelemsrc IS NOT NULL OR OLD.tel_idelemdst IS NOT NULL) THEN
    -- OK
    deltate.value_old=OLD.kwc_ilosc;
    deltate.id_old=COALESCE(OLD.tel_idelemsrc,OLD.tel_idelemdst);
   END IF; 
 END IF;

 IF (TG_OP<>'DELETE') THEN 
  IF (NEW.dmag_iddyspozycji IS NOT NULL) THEN   
   deltai_dysp.value_new=NEW.kwc_ilosc;
   deltai_dysp.id_new=NEW.dmag_iddyspozycji;
  
   IF ((NEW.kwc_flaga&16)!=0) THEN
    deltaic_dysp.value_new=NEW.kwc_ilosc;
    deltaic_dysp.id_new=NEW.dmag_iddyspozycji;
   END IF;
  END IF;
  
  IF (NEW.tel_idelemsrc IS NOT NULL OR NEW.tel_idelemdst IS NOT NULL) THEN
   deltate.value_new=NEW.kwc_ilosc;
   deltate.id_new=COALESCE(NEW.tel_idelemsrc,NEW.tel_idelemdst);
  END IF;
 
 END IF;

IF (TG_OP='UPDATE') THEN
  IF ((NEW.tel_idelemsrc IS NULL AND NOT NEW.tel_idelemdst IS NULL) OR (NEW.tel_idelemdst IS NULL AND NOT NEW.tel_idelemsrc IS NULL)) THEN
   ---sprawdzamy czy sie nie zmienil podpiecie do dokumentu - operacja niedozwolona
   IF (NEW.tel_idelemsrc!=OLD.tel_idelemsrc OR NEW.tel_idelemdst!=OLD.tel_idelemdst) THEN
    RAISE EXCEPTION 'Niedozwolona zmiana na tp_ruchy (zmiana pozycji dokumentu)';
   END IF;

   ---sprawdzamy czy dany dokument nie jest zamniety, dla zamknietych nie dozwolana operacja
   flaga=(SELECT tel_flaga FROM tg_transelem  WHERE tel_idelem=NEW.tel_idelemsrc OR tel_idelem=NEW.tel_idelemdst);
   IF ((flaga&16)=16) AND ((NEW.kwc_flaga&4)=0) AND ((OLD.kwc_flaga&4)=0) THEN
    RAISE EXCEPTION 'Niedozwolona zmiana na tp_ruchy (dokument zamkniety)';
   END IF;
  END IF;

  IF ((NEW.knr_idelemusrc IS NULL AND NOT NEW.knr_idelemudst IS NULL) OR (NEW.knr_idelemudst IS NULL AND NOT NEW.knr_idelemusrc IS NULL)) THEN
  ---sprawdzamy czy sie nie zmienil podpiecie do receptury operacji - operacja niedozwolona
   IF (NEW.knr_idelemusrc!=OLD.knr_idelemusrc OR NEW.knr_idelemudst!=OLD.knr_idelemudst) THEN
    RAISE EXCEPTION 'Niedozwolona zmiana na tp_ruchy (zmiana receptury operacji)';
   END IF;

   ---sprawdzamy czy dany dokument nie jest zamniety, dla zamknietych nie dozwolana operacja
   flaga=(SELECT kwh_flaga FROM tr_nodrec JOIN tr_kkwhead USING (kwh_idheadu)  WHERE knr_idelemu=NEW.knr_idelemusrc OR knr_idelemu=NEW.knr_idelemudst);
   IF ((flaga&1)=1) THEN
    _kwh_numer=(SELECT kwh_numer FROM tr_nodrec JOIN tr_kkwhead USING (kwh_idheadu)  WHERE knr_idelemu=NEW.knr_idelemusrc OR knr_idelemu=NEW.knr_idelemudst);
    RAISE EXCEPTION 'Niedozwolona zmiana na tr_ruchy (KKW [%] jest zamkniete)', _kwh_numer;
   END IF;

  END IF;
  --- 2014-06-27 13:39 [rp] Dezaktywuje dla: 99907/ZP ---
  --IF ((NEW.kwe_idelemusrc IS NULL AND NOT NEW.kwe_idelemudst IS NULL) OR (NEW.kwe_idelemudst IS NULL AND NOT NEW.kwe_idelemusrc IS NULL)) AND ((NEW.kwc_flaga&4)=0) AND ((OLD.kwc_flaga&4)=0) THEN
  -- RAISE EXCEPTION 'Niedozwolona zmiana na tp_ruchy (3)';
  --END IF;
  -------------------------------------------------------
 END IF;

 IF (v.deltavalueold(deltai_dysp)<>0 OR v.deltavalueold(deltaic_dysp)<>0) THEN
  UPDATE tr_dyspozycjamag SET 
  dmag_iloscwmag=dmag_iloscwmag-v.deltavalueold(deltai_dysp),
  dmag_iloscwmagclosed=dmag_iloscwmagclosed-v.deltavalueold(deltaic_dysp)
  WHERE dmag_iddyspozycji=deltai_dysp.id_old;
 END IF;

 IF (v.deltavaluenew(deltai_dysp)<>0 OR v.deltavaluenew(deltaic_dysp)<>0) THEN 
  UPDATE tr_dyspozycjamag SET 
  dmag_iloscwmag=dmag_iloscwmag+v.deltavaluenew(deltai_dysp),
  dmag_iloscwmagclosed=dmag_iloscwmagclosed+v.deltavaluenew(deltaic_dysp)
  WHERE dmag_iddyspozycji=deltai_dysp.id_new;
 END IF;
    
 IF (TG_OP='INSERT') THEN
   IF ((NEW.kwc_flaga&(1<<7))=(1<<7)) THEN
    doteupdate=TRUE;
   END IF;
 END IF;
 
 IF (TG_OP='UPDATE') THEN
   IF (((NEW.kwc_flaga&(1<<5))=(1<<5)) AND ((v.deltavalueold(deltate)!=0) OR (v.deltavaluenew(deltate)!=0))) THEN -- ruch do korekty
    RAISE EXCEPTION 'Nie mozna zmieniac ilosci na tr_ruchy';
   END IF;
 END IF;

 IF (TG_OP<>'INSERT') THEN
   IF (((OLD.kwc_flaga&(1<<3))=(1<<3)) OR ((OLD.kwc_flaga&(1<<6))=(1<<6)))  THEN -- ruch do korekty
    deltate.value_old=0;
    deltate.value_new=0;
   END IF;
 END IF;
  
 IF (TG_OP<>'DELETE') THEN
   IF (((NEW.kwc_flaga&(1<<3))=(1<<3)) OR ((NEW.kwc_flaga&(1<<6))=(1<<6)))  THEN -- ruch do korekty
    deltate.value_old=0;
    deltate.value_new=0;   
   END IF;  
 END IF;
 
 IF (v.deltavalueold(deltate)<>0) THEN
  UPDATE tg_transelem SET tel_ilosc=tel_ilosc-v.deltavalueold(deltate)*1000/tel_przelnilosci WHERE tel_idelem=deltate.id_old;
 END IF;

 IF (v.deltavaluenew(deltate)<>0) OR (doteupdate=TRUE) THEN

  UPDATE tg_transelem 
  SET tel_ilosc=tel_ilosc+v.deltavaluenew(deltate)*1000/tel_przelnilosci,tel_newflaga=tel_newflaga|64|(1<<16) 
  WHERE tel_idelem=deltate.id_new AND (v.deltavaluenew(deltate)!=0 OR ((tel_newflaga&(64|(1<<16)))!=(64|(1<<16))));
  
  IF (doteupdate=TRUE) THEN
   UPDATE tg_transelem 
   SET tel_new2flaga=tel_new2flaga|(1<<26) 
   WHERE (tel_idelem IN (SELECT tel_skojzestaw FROM tg_transelem WHERE (tel_idelem=NEW.tel_idelemsrc OR tel_idelem=NEW.tel_idelemdst) AND tel_skojzestaw IS NOT NULL)) AND
         ((tel_new2flaga&(1<<26))=0);
  END IF;
  DELETE FROM tg_transelem WHERE tel_newflaga&(64|128)<>0 AND tel_ilosc=0 AND (tel_idelem=NEW.tel_idelemsrc OR tel_idelem=NEW.tel_idelemdst);
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
