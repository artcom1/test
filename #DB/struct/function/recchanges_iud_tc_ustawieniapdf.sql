CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF (TG_OP='INSERT') THEN
  INSERT INTO tg_recchanges VALUES (94,NEW.pdf_idustawienia);
 ELSE
  PERFORM UpdateRecChange(94,OLD.pdf_idustawienia);
 END IF;
 IF (TG_OP='INSERT') THEN
  RETURN NEW;
 ELSE
  RETURN OLD;
 END IF;
END;
$$;
