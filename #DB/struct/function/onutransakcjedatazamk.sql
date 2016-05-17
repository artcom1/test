CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF ( (NEW.tr_zamknieta&1::int2) <> (OLD.tr_zamknieta&1::int2) ) THEN
  IF (NEW.tr_zamknieta&1=1 ) THEN
   NEW.tr_datazamk=now();
  ELSE 
   NEW.tr_datazamk=NULL;
  END IF;
 END IF;
 
 RETURN NEW; 
END;
$$;
