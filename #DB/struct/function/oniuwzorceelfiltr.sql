CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN


 IF (TG_OP<>'DELETE') THEN
  NEW.wz_idwzorca=(SELECT wz_idwzorca FROM kh_wzorceelem WHERE we_idelementu=NEW.we_idelementu);
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;$$;
