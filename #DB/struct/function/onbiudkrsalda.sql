CREATE FUNCTION onbiudkrsalda() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP<>'DELETE') THEN
  IF (NEW.kt_idkonta IS NOT NULL) AND ((NEW.sd_nrkontatxt IS NULL) OR (NEW.ro_idroku IS NULL)) THEN
   NEW.sd_nrkontatxt=(SELECT numerKonta(kt_prefix,kt_numer,kt_zerosto) FROM kh_konta WHERE kt_idkonta=NEW.kt_idkonta);
   NEW.ro_idroku=(SELECT ro_idroku FROm kh_konta WHERE kt_idkonta=NEW.kt_idkonta);
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
