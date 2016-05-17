CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltaold NUMERIC:=0;
 deltanew NUMERIC:=0;
 ide INT;
BEGIN

 IF (TG_OP!='INSERT') THEN
  IF (OLD.tel_idsrcelem IS NOT NULL) THEN
   deltaold=deltaold-OLD.pz_ilosc;
  END IF;
 END IF;

 IF (TG_OP!='DELETE') THEN
  IF (NEW.tel_idsrcelem IS NOT NULL) THEN
   deltanew=deltanew+NEW.pz_ilosc;
  END IF;
 END IF;
 
 IF (TG_OP='UPDATE') THEN
  IF (NEW.tel_idsrcelem IS NOT DISTINCT FROM OLD.tel_idsrcelem) THEN
   deltanew=deltanew+deltaold;
   deltaold=0;
  END IF;
 END IF;

 IF (deltaold!=0) THEN
  UPDATE tg_tecontrol SET 
  tec_pz_ilosc=tec_pz_ilosc+deltaold
  WHERE tel_idelem=OLD.tel_idsrcelem;
 END IF;
 
 IF (deltanew!=0) THEN 
  ide=(SELECT tec_id FROM tg_tecontrol WHERE tel_idelem=NEW.tel_idsrcelem);
  IF (ide IS NULL) THEN
   INSERT INTO tg_tecontrol (tel_idelem) VALUES (NEW.tel_idsrcelem);
   ide=(SELECT tec_id FROM tg_tecontrol WHERE tel_idelem=NEW.tel_idsrcelem);
  END IF;
  UPDATE tg_tecontrol SET 
  tec_pz_ilosc=tec_pz_ilosc+deltanew
  WHERE tec_id=ide;
 END IF;
 

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END
$$;
