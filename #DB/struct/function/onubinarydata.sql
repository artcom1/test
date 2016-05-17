CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN 
 UPDATE tg_pliki
 SET tpl_modificationdate = now()
 WHERE bd_iddata = NEW.bd_iddata;

 RETURN NEW;
END;
$$;
