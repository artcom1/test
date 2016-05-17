CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='DELETE') THEN
  UPDATE tg_transelem SET tel_flaga=tel_flaga|16384, tel_newflaga=tel_newflaga&(~1024) WHERE tel_idelem=OLD.tel_idelem;
  return OLD;
 END IF;

 IF (TG_OP='UPDATE') THEN
   IF (OLD.tel_idelem<>NEW.tel_idelem) THEN
     UPDATE tg_transelem SET tel_flaga=tel_flaga|16384, tel_newflaga=tel_newflaga&(~1024) WHERE tel_idelem=OLD.tel_idelem;
     UPDATE tg_transelem SET tel_flaga=tel_flaga|16384, tel_newflaga=tel_newflaga|(1024) WHERE tel_idelem=NEW.tel_idelem;
   END IF;
 END IF;

 IF (TG_OP='INSERT') THEN
  UPDATE tg_transelem SET tel_flaga=tel_flaga|16384, tel_newflaga=tel_newflaga|(1024) WHERE tel_idelem=NEW.tel_idelem;
 END IF;
  
 RETURN NEW;

END;
$$;
