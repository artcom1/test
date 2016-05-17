CREATE FUNCTION onaiudzamiloscisyncrpzam() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='DELETE') THEN
  PERFORM gm.syncrpzam_zamilosci(OLD.tel_idelem,0,0,1);
  PERFORM gm.syncrpzam_zamilosci(OLD.tel_idelem,0,0,2);
  RETURN OLD;
 END IF;
 IF (TG_OP='INSERT') THEN
  PERFORM gm.syncrpzam_zamilosci(NEW.tel_idelem,NEW.zmi_if_zreal,0,1);
  PERFORM gm.syncrpzam_zamilosci(NEW.tel_idelem,NEW.zmi_if_anul,0,2);
  RETURN NEW;
 END IF; 
 IF (TG_OP='UPDATE') THEN
  IF (NEW.zmi_if_zreal IS DISTINCT FROM OLD.zmi_if_zreal) THEN
   PERFORM gm.syncrpzam_zamilosci(NEW.tel_idelem,NEW.zmi_if_zreal,0,1);
  END IF;
  IF (NEW.zmi_if_anul IS DISTINCT FROM OLD.zmi_if_anul) THEN
   PERFORM gm.syncrpzam_zamilosci(NEW.tel_idelem,NEW.zmi_if_anul,0,2);
  END IF;
  RETURN NEW;
 END IF; 
END;
$$;
