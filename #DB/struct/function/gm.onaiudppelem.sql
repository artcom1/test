CREATE FUNCTION onaiudppelem() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='DELETE') THEN
  DELETE FROM tg_transelem WHERE tel_idelem IN (OLD.tel_idelem_plus,OLD.tel_idelem_minus);
 END IF;

 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;

 RETURN NEW;
END;
$$;
