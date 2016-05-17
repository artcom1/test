CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='DELETE') THEN
  PERFORM UpdateRecChange(8,OLD.tr_idtrans,TRUE);
  RETURN OLD;
 END IF;

 IF (TG_OP='INSERT') THEN
  PERFORM UpdateRecChange(8,NEW.tr_idtrans,TRUE);
  RETURN NEW;
 END IF;

 PERFORM UpdateRecChange(8,NEW.tr_idtrans,TRUE);
 RETURN NEW;
END;
$$;
