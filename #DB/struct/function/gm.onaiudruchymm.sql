CREATE FUNCTION onaiudruchymm() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE
 makeOpsNew BOOL:=FALSE;
 makeOpsOld BOOL:=FALSE;
BEGIN

 IF (TG_OP<>'DELETE') THEN
  makeOpsNew=TRUE;
  IF (NOT isPZet(NEW.rc_flaga) AND NOT isAPZet(NEW.rc_flaga)) OR
     (NEW.mm_idmiejsca IS NULL)
  THEN
   makeOpsNew=FALSE;
  END IF;
 END IF;

 IF (TG_OP<>'INSERT') THEN
  makeOpsOld=TRUE;
  IF (NOT isPZet(OLD.rc_flaga) AND NOT isAPZet(OLD.rc_flaga)) OR
     (OLD.mm_idmiejsca IS NULL)
  THEN
   makeOpsOld=FALSE;
  END IF;
 END IF;

 IF (makeOpsNew=TRUE) AND (makeOpsOld=TRUE) AND (TG_OP='UPDATE') THEN
  --- Nie zmienila sie ilosc oraz miejsce
  IF (OLD.rc_iloscpoz=NEW.rc_iloscpoz) AND 
     (OLD.mm_idmiejsca=NEW.mm_idmiejsca) AND 
	 (gms.getActiveIloscFromRuchPZet(OLD.rc_flaga,OLD.rc_iloscpoz,OLD.rc_iloscwzbuf)=gms.getActiveIloscFromRuchPZet(NEW.rc_flaga,NEW.rc_iloscpoz,NEW.rc_iloscwzbuf)) 
  THEN
   ---RAISE EXCEPTION 'NIe zmienilo sie';
   makeOpsNew=FALSE;
   makeOpsOld=FALSE;
  END IF;
  --- Nie zmienilo sie miejsce
  IF (OLD.mm_idmiejsca=NEW.mm_idmiejsca) THEN
   makeOpsOld=FALSE;
  END IF;
 END IF;

 IF (makeOpsOld=TRUE) THEN
  PERFORM WMSCountAll(OLD.mm_idmiejsca);
 END IF;
 IF (makeOpsNew=TRUE) THEN
  PERFORM WMSCountAll(NEW.mm_idmiejsca);
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;

$$;
