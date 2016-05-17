CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF (TG_OP='DELETE') THEN
  IF (OLD.kr_flaga&1=1) THEN
   UPDATE tg_kartypremiowe SET kr_flaga=kr_flaga|1 WHERE kr_idkarty IN (SELECT kr_idkarty FROM tg_kartypremiowe WHERE k_idklienta=OLD.k_idklienta AND kr_idkarty<>OLD.kr_idkarty ORDER BY kr_idkarty LIMIT 1);
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END; 
$$;
