CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='INSERT') THEN
  DELETE FROM tm_przynaleznosci_deleted WHERE
               mp_idref=NEW.mp_idref AND
	       mp_type=NEW.mp_type AND
	       mp_rodzaj=NEW.mp_rodzaj;
  RETURN NEW;		  
 END IF;
  
 IF (TG_OP='DELETE') THEN
  INSERT INTO tm_przynaleznosci_deleted
     (mp_idref,mp_type,mp_rodzaj)
   VALUES
     (OLD.mp_idref,OLD.mp_type,OLD.mp_rodzaj);	 
  RETURN OLD;
 END IF;


 RETURN NEW;
END;
$$;
