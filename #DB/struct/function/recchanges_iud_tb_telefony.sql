CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF (TG_OP='INSERT') THEN
  INSERT INTO tg_recchanges VALUES (188,NEW.ph_idtelefonu);
 ELSE
  PERFORM UpdateRecChange(188,OLD.ph_idtelefonu);
 END IF;
 IF (TG_OP='INSERT') THEN
  RETURN NEW;
 ELSE
  RETURN OLD;
 END IF;
END;
$$;
