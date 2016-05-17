CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN

 IF (TG_OP = 'UPDATE') THEN
  IF (NEW.vmax!=OLD.vmax) THEN
  ---kasujemy wyniki raportow ktorych nie ma zapisanych
   DELETE FROM tf_wyniki WHERE fw_idwyniku NOT IN (SELECT fw_idwyniku from tf_wynikiraportow);
  END IF;
 END IF;

 IF (TG_OP = 'DELETE') THEN
  RETURN OLD;
 END IF;

 RETURN NEW;
END;$$;
