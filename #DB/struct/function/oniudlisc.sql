CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='INSERT') THEN
  UPDATE kh_raportelem SET re_lisccnt=re_lisccnt+1 WHERE re_idelementu=NEW.re_idelementu;
 END IF;

 IF (TG_OP='DELETE') THEN
  UPDATE kh_raportelem SET re_lisccnt=re_lisccnt-1 WHERE re_idelementu=OLD.re_idelementu;
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
