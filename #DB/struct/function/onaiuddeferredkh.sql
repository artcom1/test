CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 iskh_old BOOL;
 iserror_old BOOL;
 iskh_new BOOL;
 iserror_new BOOL;
BEGIN
 
 IF (TG_OP!='INSERT') THEN
  iskh_old=(OLD.dkh_outtype!=74);
  iserror_old=(OLD.dkh_errormessage IS NOT NULL);
 END IF;
 IF (TG_OP!='DELETE') THEN
  iskh_new=(NEW.dkh_outtype!=74);
  iserror_new=(NEW.dkh_errormessage IS NOT NULL);
 END IF;

 IF (iskh_old IS NOT DISTINCT FROM iskh_new) AND (iserror_old IS NOT DISTINCT FROM iserror_new) THEN
  iskh_old=NULL;
  iserror_old=NULL;
  iskh_new=NULL;
  iserror_new=NULL;
 END IF;
  
 IF (iskh_old IS NOT NULL) THEN
  PERFORM doskojkhdeferred(-1,iskh_old,FALSE,OLD.tr_idtrans,OLD.pl_idplatnosc);
  IF (iserror_old=TRUE) THEN
   PERFORM doskojkhdeferred(-1,iskh_old,TRUE,OLD.tr_idtrans,OLD.pl_idplatnosc);
  END IF;
 END IF; 
 IF (iskh_new IS NOT NULL) THEN
  PERFORM doskojkhdeferred(1,iskh_new,FALSE,NEW.tr_idtrans,NEW.pl_idplatnosc);
  IF (iserror_new=TRUE) THEN
   PERFORM doskojkhdeferred(1,iskh_new,TRUE,NEW.tr_idtrans,NEW.pl_idplatnosc);
  END IF;
 END IF; 

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END;
$$;
