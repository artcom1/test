CREATE FUNCTION onaiudmiejscamagazynowe() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN

 IF (TG_OP='UPDATE') THEN
  IF (NEW.mm_kod!=OLD.mm_kod) THEN
   UPDATE ts_miejscamagazynowe SET mm_fullnumer=splaszczMiejsceMagazynowe(mm_idmiejsca) WHERE mm_l>NEW.mm_l AND mm_r<NEW.mm_r;
  END IF;

 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
