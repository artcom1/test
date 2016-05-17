CREATE FUNCTION oniudarchiwum() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN

 IF (TG_OP='INSERT') THEN

  IF (NEW.a_prefix IS NULL ) THEN
   IF (NEW.a_faxmail=1) THEN
     NEW.a_prefix='M';
   END IF;
   IF (NEW.a_faxmail=2) THEN
    NEW.a_prefix='F';
   END IF;
   IF (NEW.a_faxmail=3) THEN
    NEW.a_prefix='L';
   END IF;
   IF (NEW.a_faxmail=4) THEN
    NEW.a_prefix='LP';
   END IF;
   
   NEW.a_prefix=NEW.a_prefix||'/'||date_part('year',NEW.a_datanadejscia);
  END IF;

  IF (NEW.a_numer IS NULL) THEN
   NEW.a_numer=(SELECT NullZero(max(a_numer))+1 AS numer FROM tg_archiwum WHERE a_prefix=NEW.a_prefix);
  END IF;

 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
