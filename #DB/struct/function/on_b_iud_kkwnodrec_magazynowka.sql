CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN

 IF (TG_OP='INSERT') THEN
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (COALESCE(NEW.tmg_idmagazynu,0)<>COALESCE(OLD.tmg_idmagazynu,0) OR COALESCE(NEW.ttw_idtowaru,0)<>COALESCE(OLD.ttw_idtowaru,0)) THEN
   NEW.ttm_idtowmag=gettowmag(NEW.ttw_idtowaru,NEW.tmg_idmagazynu,TRUE);
  END IF; 
 END IF;

 IF (TG_OP='DELETE') THEN 
 END IF;
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
