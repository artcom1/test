CREATE FUNCTION onaiudteex() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 n NUMERIC;
BEGIN

 IF (TG_OP<>'DELETE') THEN
 
  IF (NEW.tex_flaga&3=0) THEN
   RAISE EXCEPTION 'Nie powinno byc rekordu TEEX';
  END IF;
  
  IF (NEW.tel_idelem IS NOT NULL) THEN
   IF (vendo.gettparami('TEEX_NOTEUPDATE_'||NEW.tel_idelem::text,0)=0) THEN
    n=nullZero((SELECT sum(tex_iloscf) FROM tg_teex WHERE tel_idelem=NEW.tel_idelem));
    IF (NEW.tex_flaga&3=1) THEN
     UPDATE tg_transelem SET tel_ilosc=n,tel_iloscfresttoex=0 WHERE tel_idelem=NEW.tel_idelem;
    ELSE
     UPDATE tg_transelem SET tel_iloscfresttoex=tel_iloscf-n WHERE tel_idelem=NEW.tel_idelem;
    END IF;
   END IF;
  END IF;
  
 END IF;

 IF (TG_OP='DELETE') THEN
  n=nullZero((SELECT sum(tex_iloscf) FROM tg_teex WHERE tel_idelem=OLD.tel_idelem));
  IF (OLD.tel_idelem IS NOT NULL) THEN
   IF (OLD.tex_flaga&3=1) THEN
    UPDATE tg_transelem SET tel_ilosc=n WHERE tel_idelem=OLD.tel_idelem;
   ELSE
    UPDATE tg_transelem SET tel_iloscfresttoex=tel_iloscf-n WHERE tel_idelem=OLD.tel_idelem;
   END IF;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;

 RETURN NEW;
END;
$$;
