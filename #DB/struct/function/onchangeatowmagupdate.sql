CREATE FUNCTION onchangeatowmagupdate() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='UPDATE') THEN
  IF (
      (NEW.ttm_stan<>OLD.ttm_stan) OR
      (NEW.ttm_rezerwacja<>OLD.ttm_rezerwacja)
     )
 THEN
  PERFORM UpdateRecChange(10,NEW.ttw_idtowaru);
 END IF;
END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
