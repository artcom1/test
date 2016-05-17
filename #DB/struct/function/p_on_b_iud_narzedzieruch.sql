CREATE FUNCTION p_on_b_iud_narzedzieruch() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN

 IF (TG_OP='INSERT') THEN
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (OLD.tel_idelem_odlozenie IS NOT NULL AND NEW.tel_idelem_odlozenie IS NULL) THEN
   NEW.nrr_data_odlozenia=NULL;   
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN 
 END IF;
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
