CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF (TG_OP='INSERT') THEN
  INSERT INTO tg_recchanges VALUES (138,NEW.ja_idjednostki);
 ELSE
  PERFORM UpdateRecChange(138,OLD.ja_idjednostki);
 END IF;
 IF (TG_OP='INSERT') THEN
  RETURN NEW;
 ELSE
  RETURN OLD;
 END IF;
END;
$$;
