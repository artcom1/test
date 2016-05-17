CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='UPDATE') THEN
  IF ((NEW.wp_flaga&1)=1) AND (NEW.kwe_idelemu=NULL) THEN
   DELETE FROM tp_wypal WHERE wp_idwypalu=NEW.wp_idwypalu;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
