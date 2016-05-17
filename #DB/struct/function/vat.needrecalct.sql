CREATE FUNCTION needrecalct() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF (TG_OP='DELETE') THEN
  PERFORM vat.markNeedRecalc(OLD.tr_idtrans);
  RETURN OLD;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NEW.* IS NOT DISTINCT FROM OLD.*) THEN
   RETURN NEW;
  END IF;
 END IF;

 PERFORM vat.markNeedRecalc(NEW.tr_idtrans);
 RETURN NEW;
END;
$$;
