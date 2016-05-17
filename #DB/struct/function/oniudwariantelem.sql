CREATE FUNCTION oniudwariantelem() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='INSERT') THEN
  IF (NEW.kwe_idelemu IS NOT NULL) THEN
   UPDATE tr_kkwnod SET kwe_flaga=kwe_flaga|(1<<11) WHERE kwe_idelemu=NEW.kwe_idelemu;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  IF (OLD.kwe_idelemu IS NOT NULL) THEN
   UPDATE tr_kkwnod SET kwe_flaga=kwe_flaga&(~(1<<11)) WHERE kwe_idelemu=OLD.kwe_idelemu;
  END IF;
 END IF;
        
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
