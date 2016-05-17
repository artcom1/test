CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF (TG_OP='DELETE') THEN
  IF (vat.updateVat(OLD,NULL)=TRUE) THEN
   PERFORM gm.recalcDocVat(OLD.tr_idtrans);
  END IF;
  RETURN OLD;
 END IF;
 IF (TG_OP='INSERT') THEN
  IF (vat.updateVat(NULL,NEW)=TRUE) THEN
   PERFORM gm.recalcDocVat(NEW.tr_idtrans);
  END IF;
  RETURN NEW;
 END IF;

 IF (vat.updateVat(OLD,NEW)=TRUE) THEN
  IF (OLD.tr_idtrans IS NOT DISTINCT FROM NEW.tr_idtrans) THEN
   PERFORM gm.recalcDocVat(NEW.tr_idtrans);
  ELSE
   PERFORM gm.recalcDocVat(OLD.tr_idtrans);
   PERFORM gm.recalcDocVat(NEW.tr_idtrans);
  END IF;
 END IF;
 RETURN NEW;
END;
$$;
