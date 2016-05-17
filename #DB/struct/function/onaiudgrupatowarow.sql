CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
 
 IF (TG_OP='UPDATE') THEN
  IF (NEW.tgr_nazwa!=OLD.tgr_nazwa OR NullZero(NEW.tgr_parent)!=NullZero(OLD.tgr_parent)) THEN
   UPDATE tg_grupytow SET tgr_sciezka=splaszczGrupeTowarow(tgr_idgrupy) WHERE tgr_l>NEW.tgr_l AND tgr_r<NEW.tgr_r;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
