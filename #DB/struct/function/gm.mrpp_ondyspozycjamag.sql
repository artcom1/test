CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 haspozycjaprod v.delta;
 fcb gm.tm_flagcounterbase;
BEGIN

 IF (TG_OP!='INSERT') THEN
  IF (OLD.mrpp_idpalety IS NOT NULL) THEN
   --------
   haspozycjaprod.id_old=OLD.mrpp_idpalety; 
   haspozycjaprod.value_old=1;
   --------
  END IF;
 END IF;

 IF (TG_OP!='DELETE') THEN
  IF (NEW.mrpp_idpalety IS NOT NULL) THEN
   --------
   haspozycjaprod.id_new=NEW.mrpp_idpalety; 
   haspozycjaprod.value_new=1;
   --------
  END IF;
 END IF;
 

 --------------------------------------------------------------------------------------- 
 IF (v.deltavalueold(haspozycjaprod)!=0) THEN
  fcb.mrpp_idpalety_to=haspozycjaprod.id_old;
  fcb.flc_type='MRPP_HASPOZYCJAPROD';
  PERFORM gm.flc_updatecounter(fcb,-v.deltavalueold(haspozycjaprod));
 END IF;
 IF (v.deltavaluenew(haspozycjaprod)!=0) THEN
  fcb.mrpp_idpalety_to=haspozycjaprod.id_new;
  fcb.flc_type='MRPP_HASPOZYCJAPROD';
  PERFORM gm.flc_updatecounter(fcb,v.deltavaluenew(haspozycjaprod));
 END IF;
 --------------------------------------------------------------------------------------- 
  
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END;
$$;
