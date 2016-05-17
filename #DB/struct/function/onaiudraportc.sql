CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='UPDATE') THEN
  IF (NEW.re_prefix<>OLD.re_prefix) OR (NEW.re_sufix<>OLD.re_sufix) THEN
   UPDATE kh_raportelem SET re_prefix=numerPoziomu(NEW.re_prefix,NEW.re_sufix) WHERE re_ref=NEW.re_idelementu;
  END IF;
 END IF;
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
