CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 ti RECORD;
 q TEXT;
BEGIN

 IF (TG_OP='DELETE') THEN
  SELECT * INTO ti FROM vendo.tm_tableinfo WHERE tid_datatype=OLD.v_type;
 ELSE
  SELECT * INTO ti FROM vendo.tm_tableinfo WHERE tid_datatype=NEW.v_type;
 END IF;
 
 IF (ti.tim_hasrecchanges=TRUE) THEN
  IF (TG_OP='DELETE') THEN 
   PERFORM updaterecchange(OLD.v_type,OLD.v_id);
  END IF;
  IF (TG_OP='INSERT') THEN 
   PERFORM updaterecchange(NEW.v_type,NEW.v_id);
  END IF;
  IF (TG_OP='UPDATE') THEN 
   IF (
       (COALESCE(NEW.v_value,'')<>COALESCE(OLD.v_value,'')) OR
       (COALESCE(NEW.v_valueadd,'')<>COALESCE(OLD.v_valueadd,'')) OR
       (NEW.v_flaga<>OLD.v_flaga)
      ) 
   THEN
    PERFORM updaterecchange(NEW.v_type,NEW.v_id);
   END IF;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;

 RETURN NEW;
END;
$$;
