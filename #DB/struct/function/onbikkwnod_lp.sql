CREATE FUNCTION onbikkwnod_lp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN 

 IF (NEW.knr_lp = 0) THEN
  IF (NEW.knr_idparent IS NULL) THEN
   NEW.knr_lp=nullZero((SELECT max(knr_lp) FROM tr_nodrec WHERE kwh_idheadu=NEW.kwh_idheadu AND knr_wplywmag=NEW.knr_wplywmag AND knr_idparent IS NULL))+1;
  END IF;
 END IF;
 
 RETURN NEW;
END;
$$;
