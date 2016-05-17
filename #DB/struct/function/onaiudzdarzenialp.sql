CREATE FUNCTION onaiudzdarzenialp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 _updatenexts BOOL:=FALSE;
 _updatezl BOOL:=FALSE;
 tmpint INT;
BEGIN

 IF ((TG_OP='INSERT') AND (shouldEscapeZdarzeniaTriggers()=TRUE)) THEN
  RETURN NEW;
 END IF;
 

 IF (TG_OP='INSERT') THEN
  IF (NEW.zd_idrewizja IS NOT NULL) THEN
   RETURN NEW;
  END IF;  
  
  PERFORM vendo.addOnBeforeCommitOrder(1,'Z'||NEW.zl_idzlecenia::text);
 END IF;

 -- Zrob update wszystkich dzieci
 IF (TG_OP='UPDATE') THEN
  IF (NEW.zd_idrewizja IS NOT NULL) THEN
   RETURN NEW;
  END IF;  
  
  ---RAISE WARNING 'Zlecenie %: % % ',NEW.zd_idzdarzenia,OLD.zl_idzlecenia,NEW.zl_idzlecenia;
  
  IF ( 
      (NEW.zd_lp IS DISTINCT FROM OLD.zd_lp) OR 
      (NEW.zd_lpprefix IS DISTINCT FROM OLD.zd_lpprefix) OR
      (NEW.zl_idzlecenia IS DISTINCT FROM OLD.zl_idzlecenia)
     )	 
  THEN
   
   PERFORM vendo.addOnBeforeCommitOrder(1,'Z'||NEW.zl_idzlecenia::text);
   PERFORM vendo.addOnBeforeCommitOrder(1,'Z'||OLD.zl_idzlecenia::text);

   RAISE NOTICE ':INVO: 206,%',NEW.zd_idzdarzenia;
   UPDATE tb_zdarzenia SET zd_lpprefix=toZdarzenieLPFull(NEW.zd_lpprefix,NEW.zd_lp),
                           zl_idzlecenia=NEW.zl_idzlecenia
                       WHERE zd_idparent=NEW.zd_idzdarzenia;

   IF (COALESCE(NEW.zd_wersja,0)>0) THEN					   
    UPDATE tb_zdarzenia SET zd_idparent=NEW.zd_idparent, zd_lp=NEW.zd_lp, zd_lpprefix=NEW.zd_lpprefix WHERE zd_idrewizja=NEW.zd_idzdarzenia;   
   END IF;
   
  END IF;
  
  IF (shouldEscapeZdarzeniaTriggers()=TRUE) THEN
   RETURN NEW;
  END IF;
    
  --- Zrob update nextow
  ---RAISE WARNING 'Parent %: % % ',NEW.zd_idzdarzenia,OLD.zd_idparent,NEW.zd_idparent;
  IF (COALESCE(NEW.zd_idparent,0)<>COALESCE(OLD.zd_idparent,0)) THEN
   _updatenexts=TRUE;
  END IF;
  IF (COALESCE(NEW.zl_idzlecenia,0)<>COALESCE(OLD.zl_idzlecenia,0)) THEN
    _updatenexts=TRUE;
   _updatezl=TRUE;
  END IF;
  ---Sprawdz status wykonania
  IF ((NEW.zd_flaga&12)<>(OLD.zd_flaga&12)) THEN
   PERFORM vendo.addOnBeforeCommitOrder(1,'Z'||NEW.zl_idzlecenia::text);
  END IF;

  IF (
      (NEW.zd_datarozpoczecia<>OLD.zd_datarozpoczecia) OR 
      (NEW.zd_datazakonczenia<>OLD.zd_datazakonczenia) OR
      ((NEW.zd_flaga&(1<<16))<>(OLD.zd_flaga&(1<<16)))
     ) 
 THEN
  PERFORM vendo.addOnBeforeCommitOrder(1,'Z'||NEW.zl_idzlecenia::text);
 END IF;

 END IF;
 
 IF (TG_OP='DELETE') THEN
  IF (OLD.zd_idrewizja IS NOT NULL) THEN
   RETURN OLD;
  END IF;  
  
  _updatenexts=TRUE;
   PERFORM vendo.addOnBeforeCommitOrder(1,'Z'||OLD.zl_idzlecenia::text);
 END IF;

  ---RAISE WARNING 'Jestem w zl %',_updatenexts;
 IF (_updatenexts=TRUE) THEN
  _updatezl=TRUE;
  IF (OLD.zl_idzlecenia IS NOT NULL) THEN 
   RAISE NOTICE ':Update Nextow: %',OLD.zd_lp;
   PERFORM doescapezdarzeniatriggers(1);
   UPDATE tb_zdarzenia SET zd_lp=zd_lp-1 
                       WHERE zd_lp>OLD.zd_lp 
 		       AND zd_idzdarzenia<>OLD.zd_idzdarzenia
			   AND zd_idrewizja IS NULL 
		       AND (
		            (OLD.zd_idparent IS NOT NULL AND zd_idparent=OLD.zd_idparent) OR
		            (OLD.zd_idparent IS NULL AND zd_idparent IS NULL)
			   )
		       AND (
		            (OLD.zd_idparent IS NOT NULL) OR
		            (OLD.zl_idzlecenia IS NOT NULL AND zl_idzlecenia=OLD.zl_idzlecenia) OR
			    (OLD.zl_idzlecenia IS NULL AND zl_idzlecenia IS NULL)
			   );
   PERFORM doescapezdarzeniatriggers(-1);
  END IF;
  ------------------------------------------------------
  IF (_updatezl=TRUE) THEN
   PERFORM vendo.addOnBeforeCommitOrder(1,'Z'||OLD.zl_idzlecenia::text);
  END IF;
 END IF;


 IF (TG_OP='DELETE') THEN

  IF (OLD.zl_idzlecenia IS NOT NULL) THEN
   PERFORM vendo.addOnBeforeCommitOrder(1,'C'||OLD.zl_idzlecenia::text);
  END IF;
 
  RETURN OLD;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (
      (NEW.zd_lp IS DISTINCT FROM OLD.zd_lp) OR
	  (NEW.zl_idzlecenia IS DISTINCT FROM OLD.zl_idzlecenia) OR
	  (NEW.zd_idparent IS DISTINCT FROM OLD.zd_idparent)
	 )
  THEN 
   PERFORM vendo.addOnBeforeCommitOrder(1,'C'||OLD.zl_idzlecenia::text);
  END IF;
 ELSE
 
  IF (NEW.zl_idzlecenia IS NOT NULL) THEN
  PERFORM vendo.addOnBeforeCommitOrder(1,'C'||NEW.zl_idzlecenia::text);
  END IF;

 END IF;

 RETURN NEW;
END;
$$;
