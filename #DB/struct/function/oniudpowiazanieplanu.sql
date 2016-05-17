CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN

 IF (TG_OP = 'INSERT') THEN
  IF (NEW.pw_ile>0) THEN
   UPDATE tg_planzlecenia SET pz_flaga=pz_flaga|16 WHERE pz_idplanu=NEW.pz_idplanu ;
  END IF;
 END IF;

 IF (TG_OP = 'UPDATE') THEN

  IF (NEW.pz_idplanu<>OLD.pz_idplanu) THEN
    RAISE EXCEPTION 'Nie mozna w ten sposob zmieniac planu';
  END IF;

  IF (NEW.pw_ile<=0 AND OLD.pw_ile>0) THEN
   UPDATE tg_planzlecenia SET pz_flaga=pz_flaga&(~16) WHERE pz_idplanu=NEW.pz_idplanu ;
  END IF;

  IF (NEW.pw_ile>0 AND OLD.pw_ile<=0) THEN
   UPDATE tg_planzlecenia SET pz_flaga=pz_flaga|16 WHERE pz_idplanu=NEW.pz_idplanu ;
  END IF;

 END IF;

 IF (TG_OP = 'DELETE') THEN
  UPDATE tg_planzlecenia SET pz_flaga=pz_flaga&(~16) WHERE pz_idplanu=OLD.pz_idplanu ;
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END;$$;
