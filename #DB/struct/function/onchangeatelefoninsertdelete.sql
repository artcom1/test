CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP<>'DELETE') THEN

  IF (NEW.ph_datatype=1) THEN
   PERFORM UpdateRecChange(1,NEW.ph_id);
  END IF;

 END IF;

 IF (TG_OP<>'INSERT') THEN

  IF (OLD.ph_datatype=1) THEN
   PERFORM UpdateRecChange(1,OLD.ph_id);
  END IF;

 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
