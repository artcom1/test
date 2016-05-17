CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
 ---Trigger AFTER dla podindeksow

 IF (NEW.ttw_idxref IS NULL) THEN
  RETURN NEW;
 END IF;

 IF (TG_OP='INSERT') THEN
  UPDATE tg_towary 
  SET ttw_newflaga=ttw_newflaga|(1<<22)
  WHERE ttw_idtowaru=NEW.ttw_idxref AND
        (ttw_newflaga&(1<<22))=0;
		
  --Synchronizacja cen		
  IF ((NEW.ttw_newflaga&(1<<24))!=0) THEN
   PERFORM gm.syncCenyTow(NEW.ttw_idxref,NEW.ttw_idtowaru);
  END IF;
  
 END IF;
  
 IF (TG_OP='UPDATE') THEN
  IF (
      (NEW.ttw_ostcena IS DISTINCT FROM OLD.ttw_ostcena) OR
	  (NEW.ttw_ostcenanab IS DISTINCT FROM OLD.ttw_ostcenanab) OR
	  (NEW.ttw_ostatniadostawa IS DISTINCT FROM OLD.ttw_ostatniadostawa) OR
	  (NEW.ttw_idostwaluty IS DISTINCT FROM OLD.ttw_idostwaluty)
	 )
  THEN
   UPDATE tg_towary SET
      ttw_ostcena=NEW.ttw_ostcena,
	  ttw_ostcenanab=NEW.ttw_ostcenanab,
	  ttw_ostatniadostawa=NEW.ttw_ostatniadostawa,
	  ttw_idostwaluty=NEW.ttw_idostwaluty
   WHERE ttw_idtowaru=NEW.ttw_idxref AND
      (
       (ttw_ostcena IS DISTINCT FROM NEW.ttw_ostcena) OR
	   (ttw_ostcenanab IS DISTINCT FROM NEW.ttw_ostcenanab) OR
	   (ttw_ostatniadostawa IS DISTINCT FROM NEW.ttw_ostatniadostawa) OR
	   (ttw_idostwaluty IS DISTINCT FROM NEW.ttw_idostwaluty)
	  );
  END IF;
  --Synchronizacja cen		
  IF ((NEW.ttw_newflaga&(1<<24))!=0) AND ((OLD.ttw_newflaga&(1<<24))=0) THEN
   PERFORM gm.syncCenyTow(NEW.ttw_idxref,NEW.ttw_idtowaru);
  END IF;
 END IF;
  
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END
$$;
