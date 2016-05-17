CREATE FUNCTION oniudwynikiraportow() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN

 IF (TG_OP = 'DELETE') THEN
  DELETE FROM tf_wyniki WHERE fw_idwyniku=OLD.fw_idwyniku;
 END IF;

 IF (TG_OP = 'DELETE') THEN
  RETURN OLD;
 END IF;

 RETURN NEW;
END;$$;