CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltawm NUMERIC:=0;
 kwh_id INT;
 pz_id INT;
BEGIN
 IF (TG_OP<>'INSERT') THEN
  
  kwh_id=(SELECT kwh_idheadu FROM tp_kkwelem WHERE kwe_idelemu=OLD.kwr_etapsrc);

  IF (OLD.kwr_etapsrc IS NOT NULL) AND (OLD.tel_idelemdst IS NOT NULL) THEN
   deltawm=deltawm-OLD.kwr_ilosc;
  END IF;

 END IF;
 
 IF (TG_OP<>'DELETE') THEN

  kwh_id=(SELECT kwh_idheadu FROM tp_kkwelem WHERE kwe_idelemu=NEW.kwr_etapsrc);

  IF (NEW.kwr_etapsrc IS NOT NULL) AND (NEW.tel_idelemdst IS NOT NULL) THEN
   deltawm=deltawm+NEW.kwr_ilosc;
  END IF;

 END IF;

 IF (deltawm<>0) THEN
  pz_id=(SELECT pz_idplanu FROM tp_kkwhead JOIN tp_kkwplan USING (kwp_idplanu) WHERE kwh_idheadu=kwh_id);
  IF (pz_id>0) THEN
   UPDATE tg_planzlecenia SET pz_ilosczreal=getIloscWMag(pz_id) WHERE pz_idplanu=pz_id;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
