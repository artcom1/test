CREATE FUNCTION recchanges_iud_tg_transakcje() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF (TG_OP='INSERT') THEN
  INSERT INTO tg_recchanges VALUES (8,NEW.tr_idtrans);
 ELSE
  PERFORM UpdateRecChange(8,OLD.tr_idtrans);
 END IF;
 IF (TG_OP='INSERT') THEN
  RETURN NEW;
 ELSE
  RETURN OLD;
 END IF;
END;
$$;
