CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
 
 IF (TG_OP='UPDATE') THEN
  IF (NEW.opk_nazwa!=OLD.opk_nazwa OR NullZero(NEW.opk_parent)!=NullZero(OLD.opk_parent)) THEN
   UPDATE ts_osrodkipk  SET opk_sciezka=splaszczOsrodekPK(opk_idosrodka) WHERE opk_l>NEW.opk_l AND opk_r<NEW.opk_r;  
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
