CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF (TG_OP='INSERT') THEN
  INSERT INTO tg_recchanges VALUES (133,NEW.sz_idskladnika);
 ELSE
  PERFORM UpdateRecChange(133,OLD.sz_idskladnika);
 END IF;
 IF (TG_OP='INSERT') THEN
  RETURN NEW;
 ELSE
  RETURN OLD;
 END IF;
END;
$$;
