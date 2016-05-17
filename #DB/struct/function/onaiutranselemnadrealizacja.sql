CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN 

 IF (NEW.tel_nadmiarzam=OLD.tel_nadmiarzam) THEN
  RETURN NEW;
 END IF;
 
 IF (checkMozliwaNadrealizacja(NEW.tr_idtrans)=FALSE) THEN
  RAISE EXCEPTION '49|%|Wprowadzenie podanej ilosci spowodowaloby nadrealizacje',NEW.tel_idelem;
 END IF;
 
 RETURN NEW;
END;
$$;
