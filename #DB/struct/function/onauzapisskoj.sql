CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (NEW.zs_counter=0) AND (NEW.zs_counterext=0) THEN
  DELETE FROM kh_zapisskoj WHERE zs_idskoj=NEW.zs_idskoj;
 END IF;

 RETURN NEW;
END;
$$;
