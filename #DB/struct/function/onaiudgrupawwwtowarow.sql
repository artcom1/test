CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
 
 IF (TG_OP='UPDATE') THEN
  IF (NEW.tgw_nazwa!=OLD.tgw_nazwa OR NullZero(NEW.tgw_parent)!=NullZero(OLD.tgw_parent)) THEN
   UPDATE tg_grupywww SET tgw_sciezka=splaszczGrupeWWWTowarow(tgw_idgrupy) WHERE tgw_l>NEW.tgw_l AND tgw_r<NEW.tgw_r;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
