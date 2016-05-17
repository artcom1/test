CREATE FUNCTION recchanges_iud_ts_banki() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF (TG_OP='INSERT') THEN
  INSERT INTO tg_recchanges VALUES (21,NEW.bk_idbanku);
 ELSE
  PERFORM UpdateRecChange(21,OLD.bk_idbanku);
 END IF;
 IF (TG_OP='INSERT') THEN
  RETURN NEW;
 ELSE
  RETURN OLD;
 END IF;
END;
$$;
