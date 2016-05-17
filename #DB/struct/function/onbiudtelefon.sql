CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP!='DELETE') THEN
  IF ((NEW.ph_type&(1<<0))!=0) THEN
   NEW.ph_phonenorm=normphone(NEW.ph_phone);
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 RETURN NEW;
END;
$$;
