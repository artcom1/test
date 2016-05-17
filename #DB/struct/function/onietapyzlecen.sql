CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN

 IF (NEW.sz_status>0) THEN
  UPDATE tg_zlecenia SET sz_idetapu=NEW.sz_idetapu WHERE zl_idzlecenia=NEW.zl_idzlecenia;
 END IF;
 RETURN NEW;
END;
$$;
