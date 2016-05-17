CREATE FUNCTION mrpp_onaiudruch() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 haspozycjamag v.delta;
 hasapz v.delta;
 hasniewydane v.delta;
 fcb gm.tm_flagcounterbase;
BEGIN

 IF (TG_OP!='INSERT') THEN
  IF (OLD.mrpp_idpalety IS NOT NULL) THEN
   --------
   haspozycjamag.id_old=OLD.mrpp_idpalety; 
   IF (isPZet(OLD.rc_flaga) OR isAPZet(OLD.rc_flaga)) THEN
    haspozycjamag.value_old=1;
   END IF;
   --------
   hasapz.id_old=OLD.mrpp_idpalety; 
   IF (isAPZet(OLD.rc_flaga)) THEN
    hasapz.value_old=1;
   END IF;
   --------
   hasniewydane.id_old=OLD.mrpp_idpalety;
   IF (isPZet(OLD.rc_flaga) AND OLD.rc_iloscpoz>0) THEN
    hasniewydane.value_old=1;
   END IF;
   --------
  END IF;
 END IF;

 IF (TG_OP!='DELETE') THEN
  IF (NEW.mrpp_idpalety IS NOT NULL) THEN
   --------
   haspozycjamag.id_new=NEW.mrpp_idpalety; 
   IF (isPZet(NEW.rc_flaga) OR isAPZet(NEW.rc_flaga)) THEN
    haspozycjamag.value_new=1;
   END IF;
   --------
   hasapz.id_new=NEW.mrpp_idpalety; 
   IF (isAPZet(NEW.rc_flaga)) THEN
    hasapz.value_new=1;
   END IF;
   --------
   hasniewydane.id_new=NEW.mrpp_idpalety;
   IF (isPZet(NEW.rc_flaga) AND NEW.rc_iloscpoz>0) THEN
    hasniewydane.value_new=1;
   END IF;
   --------
  END IF;
 END IF;
 

 --------------------------------------------------------------------------------------- 
 IF (v.deltavalueold(haspozycjamag)!=0) THEN
  fcb.mrpp_idpalety_to=haspozycjamag.id_old;
  fcb.flc_type='MRPP_HASPOZYCJAMAG';
  PERFORM gm.flc_updatecounter(fcb,-v.deltavalueold(haspozycjamag));
 END IF;
 IF (v.deltavaluenew(haspozycjamag)!=0) THEN
  fcb.mrpp_idpalety_to=haspozycjamag.id_new;
  fcb.flc_type='MRPP_HASPOZYCJAMAG';
  PERFORM gm.flc_updatecounter(fcb,v.deltavaluenew(haspozycjamag));
 END IF;
 --------------------------------------------------------------------------------------- 
 IF (v.deltavalueold(hasapz)!=0) THEN
  fcb.mrpp_idpalety_to=hasapz.id_old;
  fcb.flc_type='MRPP_HASAPZ';
  PERFORM gm.flc_updatecounter(fcb,-v.deltavalueold(hasapz));
 END IF;
 IF (v.deltavaluenew(hasapz)!=0) THEN
  fcb.mrpp_idpalety_to=hasapz.id_new;
  fcb.flc_type='MRPP_HASAPZ';
  PERFORM gm.flc_updatecounter(fcb,v.deltavaluenew(hasapz));
 END IF;
 --------------------------------------------------------------------------------------- 
 IF (v.deltavalueold(hasniewydane)!=0) THEN
  fcb.mrpp_idpalety_to=hasniewydane.id_old;
  fcb.flc_type='MRPP_HASNIEWYDANYPZ';
  PERFORM gm.flc_updatecounter(fcb,-v.deltavalueold(hasniewydane));
 END IF;
 IF (v.deltavaluenew(hasniewydane)!=0) THEN
  fcb.mrpp_idpalety_to=hasniewydane.id_new;
  fcb.flc_type='MRPP_HASNIEWYDANYPZ';
  PERFORM gm.flc_updatecounter(fcb,v.deltavaluenew(hasniewydane));
 END IF;
 --------------------------------------------------------------------------------------- 
  
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END;
$$;
