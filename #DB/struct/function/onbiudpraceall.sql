CREATE FUNCTION onbiudpraceall() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 roznica INTERVAL;
 rbh     NUMERIC:=0;
 old_rbh  NUMERIC:=0;
 new_rbh  NUMERIC:=0;
 
 _zd_idzdarzenia_new INT;
 _zd_idzdarzenia_old INT;
BEGIN
 ------------------------------------------------------------------------------
 ---WYLICZENIE RBH NA PODSTAWIE DAT JESLI REJESTRACJA START-STOP
 ------------------------------------------------------------------------------
 IF (TG_OP<>'DELETE') THEN
  IF (NEW.pra_flaga&1=1) THEN
   IF (NEW.pra_flaga&2=2) THEN
    roznica=NEW.pra_datastop-NEW.pra_datastart;
    rbh=date_part('days',roznica)*24+date_part('hours',roznica)+date_part('minute',roznica)/60;
    rbh=round(rbh,2);
    NEW.pra_rbh=rbh;
   ELSE
    NEW.pra_rbh=0;
   END IF;
  END IF;
 END IF;

 -----------------------------------------------------------------------------------
 --- AKUMULATOR RBH ZDARZEN
 ----------------------------------------------------------------------------------- 
 -- DELETE lub UPDATE
 IF (TG_OP='UPDATE' OR TG_OP='DELETE') THEN
  old_rbh=-OLD.pra_rbh;  
 END IF;
 
 -- INSERT lub UPDATE 
 IF (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
  new_rbh=NEW.pra_rbh;
 END IF ;

  IF (TG_OP='UPDATE') THEN
   IF (COALESCE(NEW.pra_idref,0)=COALESCE(OLD.pra_idref,0)) AND (COALESCE(NEW.pra_typeref,0)=COALESCE(OLD.pra_typeref,0)) THEN
    new_rbh=new_rbh+old_rbh;
	old_rbh=0;
   END IF;
  END IF;
  
  IF (old_rbh<>0) THEN
   IF (OLD.pra_typeref=206) THEN -- Zdarzenia
    _zd_idzdarzenia_old=OLD.pra_idref;
   END IF;
   
   IF (OLD.pra_typeref=56) THEN -- PlanZlecenia
    _zd_idzdarzenia_old=(SELECT zd_idzdarzenia FROM tg_planzlecenia WHERE pz_idplanu=OLD.pra_idref);
   END IF;
   
   IF (COALESCE(_zd_idzdarzenia_old,0)>0) THEN
    UPDATE tb_zdarzenia SET zd_rbh=zd_rbh+old_rbh WHERE zd_idzdarzenia=_zd_idzdarzenia_old;
   END IF;   
  END IF;
  
  IF (new_rbh<>0) THEN
   IF (NEW.pra_typeref=206) THEN -- Zdarzenia
    _zd_idzdarzenia_new=NEW.pra_idref;
   END IF;
   
   IF (NEW.pra_typeref=56) THEN -- PlanZlecenia
    _zd_idzdarzenia_new=(SELECT zd_idzdarzenia FROM tg_planzlecenia WHERE pz_idplanu=NEW.pra_idref);
   END IF;
      
   IF (COALESCE(_zd_idzdarzenia_new,0)>0) THEN
    UPDATE tb_zdarzenia SET zd_rbh=zd_rbh+new_rbh WHERE zd_idzdarzenia=_zd_idzdarzenia_new;
   END IF;  
  END IF;  
  
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
  
 RETURN NEW;

END;
$$;
