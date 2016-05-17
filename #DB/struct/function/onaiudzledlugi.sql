CREATE FUNCTION onaiudzledlugi() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltaold NUMERIC:=0;
 deltanew NUMERIC:=0;
BEGIN

 IF (TG_OP<>'INSERT') THEN
  deltaold=deltaold-OLD.kzld_wartosc;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  deltanew=deltanew+NEW.kzld_wartosc;
 END IF;


 IF (TG_OP='UPDATE') THEN
  IF (OLD.kzl_id IS NOT DISTINCT FROM NEW.kzl_id) THEN
   deltanew=deltanew+deltaold;
   deltaold=0;
  END IF;
 END IF;
 
 IF (deltaold<>0) THEN
  UPDATE kh_zledlugi SET kzl_wartoscjest=kzl_wartoscjest+deltaold WHERE kzl_id=OLD.kzl_id;
  deltaold=0;
 END IF;

 IF (deltanew<>0) THEN
  UPDATE kh_zledlugi SET kzl_wartoscjest=kzl_wartoscjest+deltanew WHERE kzl_id=NEW.kzl_id;
  deltanew=0;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;

 RETURN NEW;
END;
$$;
