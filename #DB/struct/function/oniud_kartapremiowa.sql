CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='INSERT') THEN

  IF (nullZero((SELECT count(*) FROM tg_kartypremiowe WHERE kr_flaga&1=1 AND k_idklienta=NEW.k_idklienta AND kr_idkarty<>NEW.kr_idkarty))=0) THEN
   NEW.kr_flaga=NEW.kr_flaga|1;
  END IF;

 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
