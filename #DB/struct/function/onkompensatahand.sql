CREATE FUNCTION onkompensatahand() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 dilosco NUMERIC:=0;
 diloscn NUMERIC:=0;
BEGIN

 IF (TG_OP='DELETE') OR (TG_OP='UPDATE') THEN
  dilosco=-OLD.kh_ilosc;
 END IF;

 IF (TG_OP='INSERT') OR (TG_OP='UPDATE') THEN
  diloscn=NEW.kh_ilosc;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NEW.kh_idfaktury=OLD.kh_idfaktury) THEN
   diloscn=diloscn+dilosco;
   dilosco=0;
  END IF;
 END IF;


 IF (dilosco<>0) THEN
  UPDATE tg_transelem SET tel_iloscwyd=tel_iloscwyd-dilosco WHERE tel_idelem=OLD.kh_idfaktury;
 END IF;

 IF (diloscn<>0) THEN
  UPDATE tg_transelem SET tel_iloscwyd=tel_iloscwyd-diloscn WHERE tel_idelem=NEW.kh_idfaktury;
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
