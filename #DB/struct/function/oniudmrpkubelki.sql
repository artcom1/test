CREATE FUNCTION oniudmrpkubelki() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 dataroz TIMESTAMP;
 datazak TIMESTAMP;
 zmiana RECORD;
BEGIN
 IF (TG_OP='UPDATE') THEN
 ---przy zapisywaniu zmian sprawdzamy czy mamy cos zakualizowac
  IF ((NEW.kb_flaga&1)=1) THEN
  --do kubelka sa plany wiec je uaktualniamy jesli byly jakies zmiany
   IF (NEW.kb_data<>OLD.kb_data OR NEW.zm_idzmiany<>OLD.zm_idzmiany) THEN
    ---zmiana daty i zmiany
    ---pobieramy date rozpoczecia i zakonczenia
    SELECT * INTO zmiana FROM tr_zmiany WHERE zm_idzmiany=NEW.zm_idzmiany;
    dataroz=(NEW.kb_data||' '||zmiana.zm_godzinaroz)::timestamp;
    IF (zmiana.zm_godzinaroz<zmiana.zm_godzinazak) THEN 
     datazak=(NEW.kb_data||' '||zmiana.zm_godzinazak)::timestamp;
    ELSE ---zmiana przechodzaca przez polnoc dodajemy do daty jeden dzien
     datazak=(NEW.kb_data+1||' '||zmiana.zm_godzinazak)::timestamp;
    END IF;
    UPDATE tr_kkwnodplan SET knp_datarozpoczecia=dataroz, knp_datazakonczenia=datazak WHERE knp_flaga&(1|2|32)=32 AND kb_idkubelka=NEW.kb_idkubelka;
   END IF;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
