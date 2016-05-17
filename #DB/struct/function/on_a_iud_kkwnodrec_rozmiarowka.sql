CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 _knr_idelemu INT;
 _knr_flaga   INT;
BEGIN

 IF (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
  _knr_idelemu=NEW.knr_idelemu;
  _knr_flaga=NEW.knr_flaga;
 ELSE
  _knr_idelemu=OLD.knr_idelemu;
  _knr_flaga=OLD.knr_flaga;
 END IF;

 IF (_knr_flaga&(1<<12)=0) THEN
  DELETE FROM tr_nodrecrozmiarowka WHERE knr_idelemu=_knr_idelemu;
 END IF;

-- IF ((_knr_flaga&(1<<12)=(1<<12)) AND TG_OP<>'DELETE') THEN    
-- END IF; 
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END;
$$;
