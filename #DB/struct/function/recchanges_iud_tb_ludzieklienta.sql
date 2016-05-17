CREATE FUNCTION recchanges_iud_tb_ludzieklienta() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF (TG_OP='INSERT') THEN
  INSERT INTO tg_recchanges VALUES (35,NEW.lk_idczklienta);
 ELSE
  PERFORM UpdateRecChange(35,OLD.lk_idczklienta);
 END IF;
 IF (TG_OP='INSERT') THEN
  RETURN NEW;
 ELSE
  RETURN OLD;
 END IF;
END;
$$;
