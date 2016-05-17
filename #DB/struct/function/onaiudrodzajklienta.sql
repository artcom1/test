CREATE FUNCTION onaiudrodzajklienta() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
 
 IF (TG_OP='UPDATE') THEN
  IF (NEW.rk_typrodzaju!=OLD.rk_typrodzaju OR NullZero(NEW.rk_parent)!=NullZero(OLD.rk_parent)) THEN
   UPDATE ts_rodzajklienta  SET rk_sciezka=splaszczRodzajKlienta(rk_idrodzajklienta) WHERE rk_l>NEW.rk_l AND rk_r<NEW.rk_r;
  
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
