CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE  
BEGIN
 
 IF (TG_OP='INSERT') THEN
  IF ((NEW.pw_flaga&(1<<0))=0) THEN -- nie wymaga KJ
    NEW.pw_data_kj=now();
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
