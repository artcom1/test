CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF (TG_OP='INSERT') THEN
  INSERT INTO tg_recchanges VALUES (50,NEW.iu_idinwdupusty);
 ELSE
  PERFORM UpdateRecChange(50,OLD.iu_idinwdupusty);
 END IF;
 IF (TG_OP='INSERT') THEN
  RETURN NEW;
 ELSE
  RETURN OLD;
 END IF;
END;
$$;
