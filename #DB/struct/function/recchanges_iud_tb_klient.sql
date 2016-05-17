CREATE FUNCTION recchanges_iud_tb_klient() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF (TG_OP='INSERT') THEN
  INSERT INTO tg_recchanges VALUES (1,NEW.k_idklienta);
 ELSE
  PERFORM UpdateRecChange(1,OLD.k_idklienta);
 END IF;
 IF (TG_OP='INSERT') THEN
  RETURN NEW;
 ELSE
  RETURN OLD;
 END IF;
END;
$$;
