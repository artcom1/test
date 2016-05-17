CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltailosc       NUMERIC:=0;
 deltailosczreal  NUMERIC:=0;
 deltailosczrealc NUMERIC:=0;
 ide              INT;
 _pz_idplanu      INT;
BEGIN

 IF (TG_OP!='INSERT') THEN
  deltailosc=deltailosc-(OLD.pzw_iloscop*OLD.pzw_mnoznikop);
  deltailosczreal=deltailosczreal-OLD.pzw_ilosczreal;
  deltailosczrealc=deltailosczrealc-OLD.pzw_ilosczrealclosed;
  _pz_idplanu=OLD.pz_idplanu;
 END IF;

 IF (TG_OP!='DELETE') THEN
  deltailosc=deltailosc+(NEW.pzw_iloscop*NEW.pzw_mnoznikop);
  deltailosczreal=deltailosczreal+NEW.pzw_ilosczreal;
  deltailosczrealc=deltailosczrealc+NEW.pzw_ilosczrealclosed;  
  _pz_idplanu=NEW.pz_idplanu;
 END IF;
 
 IF (deltailosc!=0 OR deltailosczreal!=0 OR deltailosczrealc!=0) THEN
  UPDATE tg_planzlecenia SET 
  pz_ilosczreal=pz_ilosczreal+deltailosczreal,
  pz_ilosczrealclosed=pz_ilosczrealclosed+deltailosczrealc   
  WHERE pz_idplanu=_pz_idplanu;
   
  IF (TG_OP='DELETE') THEN   
   IF (OLD.tel_idsrcelem IS NOT NULL) THEN
    UPDATE tg_tecontrol SET 
    tec_pz_ilosc=tec_pz_ilosc+deltailosc,
    tec_pz_ilosczreal=tec_pz_ilosczreal+deltailosczreal,
    tec_pz_ilosczrealclosed=tec_pz_ilosczrealclosed+deltailosczrealc
    WHERE tel_idelem=OLD.tel_idsrcelem;
   END IF;
  ELSE   
   IF (NEW.tel_idsrcelem IS NOT NULL) THEN
    ide=(SELECT tec_id FROM tg_tecontrol WHERE tel_idelem=NEW.tel_idsrcelem);
    IF (ide IS NULL) THEN
     INSERT INTO tg_tecontrol (tel_idelem) VALUES (NEW.tel_idsrcelem);
     ide=(SELECT tec_id FROM tg_tecontrol WHERE tel_idelem=NEW.tel_idsrcelem);
    END IF;
    UPDATE tg_tecontrol SET 
    tec_pz_ilosc=tec_pz_ilosc+deltailosc,
    tec_pz_ilosczreal=tec_pz_ilosczreal+deltailosczreal,
    tec_pz_ilosczrealclosed=tec_pz_ilosczrealclosed+deltailosczrealc
    WHERE tec_id=ide;  
   END IF;
  END IF;
 END IF;
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 RETURN NEW;
END;
$$;
