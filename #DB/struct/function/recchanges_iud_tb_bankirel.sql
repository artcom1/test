CREATE FUNCTION recchanges_iud_tb_bankirel() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF (TG_OP='INSERT') THEN
  INSERT INTO tg_recchanges VALUES (215,NEW.br_idrelacji);
 ELSE
  PERFORM UpdateRecChange(215,OLD.br_idrelacji);
 END IF;
 IF (TG_OP='INSERT') THEN
  RETURN NEW;
 ELSE
  RETURN OLD;
 END IF;
END;
$$;
