CREATE FUNCTION onadkkwnod_lp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='DELETE') THEN  
  IF (OLD.knr_idparent IS NULL) THEN
   UPDATE tr_nodrec SET knr_lp=knr_lp-1 WHERE kwh_idheadu=OLD.kwh_idheadu AND knr_lp>OLD.knr_lp AND knr_wplywmag=OLD.knr_wplywmag AND knr_idparent IS NULL;
  END IF;
 END IF;

 RETURN OLD;
END;
$$;
