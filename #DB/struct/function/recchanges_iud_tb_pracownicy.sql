CREATE FUNCTION recchanges_iud_tb_pracownicy() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF (TG_OP='INSERT') THEN
  INSERT INTO tg_recchanges VALUES (11,NEW.p_idpracownika);
 ELSE
  PERFORM UpdateRecChange(11,OLD.p_idpracownika);
 END IF;
 IF (TG_OP='INSERT') THEN
  RETURN NEW;
 ELSE
  RETURN OLD;
 END IF;
END;
$$;
