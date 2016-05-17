CREATE FUNCTION onppheadelemiud() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltapp v.delta;
BEGIN

 IF (TG_OP!='DELETE') THEN  
  IF (NEW.phe_ref IS NULL) THEN
   PERFORM gmr.syncPPHeadElem(NEW.phe_idheadelemu,NEW.ttw_idtowarundx,NEW.rmp_idsposobu,NEW.phe_iloscop,NEW.phe_iloscopdone);
  ELSE
   ---Synchronizuj rezerwacje etc
  END IF;
 END IF;

 IF (TG_OP!='INSERT') THEN 
  IF (OLD.phe_ref IS NOT NULL) AND (OLD.phe_docclosed=FALSE) THEN
   deltapp.value_old=(OLD.phe_iloscop*OLD.phe_mnoznik);
   deltapp.id_old=OLD.tel_idelemsrcskoj;
  END IF;
 END IF;
 
 IF (TG_OP!='DELETE') THEN 
  IF (NEW.phe_ref IS NOT NULL) AND (NEW.phe_docclosed=FALSE) THEN
   deltapp.value_new=(NEW.phe_iloscop*NEW.phe_mnoznik);
   deltapp.id_new=NEW.tel_idelemsrcskoj;
  END IF;
 END IF;
  
 IF (v.deltavalueold(deltapp)!=0) THEN
  UPDATE tg_zamilosci SET zmi_if_inprzepakowanie=zmi_if_inprzepakowanie-v.deltavalueold(deltapp) WHERE tel_idelem=deltapp.id_old;
 END IF;
 IF (v.deltavaluenew(deltapp)!=0) THEN
  UPDATE tg_zamilosci SET zmi_if_inprzepakowanie=zmi_if_inprzepakowanie+v.deltavaluenew(deltapp) WHERE tel_idelem=deltapp.id_new;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END;
$$;
