CREATE FUNCTION onubanki() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
 doUpdate BOOL:=false;
BEGIN
 
 IF ((NEW.tr_zamknieta&64)=0) THEN
  NEW.bk_idbankuwal=NULL;
  NEW.bk_idbankupln=NULL;
  RETURN NEW;
 END IF;
 
 IF (TG_OP='INSERT') THEN
  doUpdate=TRUE;
 END IF;
 
 IF (doUpdate=FALSE) AND (TG_OP='UPDATE') THEN
  IF ((NEW.fm_idcentrali IS DISTINCT FROM OLD.fm_idcentrali) OR 
      (NEW.k_idklienta IS DISTINCT FROM OLD.k_idklienta) OR 
	  (NEW.tmg_idmagazynu IS DISTINCT FROM OLD.tmg_idmagazynu) OR
	  (NEW.wl_idwaluty IS DISTINCT FROM OLD.wl_idwaluty)
	 )
  THEN
   doUpdate=TRUE;
  END IF;
 END IF;
 
 IF (doUpdate=TRUE) THEN
  NEW.bk_idbankuwal=getbankdlaklienta(NEW.fm_idcentrali,NEW.k_idklienta,NEW.tmg_idmagazynu,NEW.wl_idwaluty);
  IF (gm.hasosobnyrozrachunekvat(NEW.tr_zamknieta,NEW.tr_newflaga,NEW.wl_idwaluty)=TRUE) THEN
   NEW.bk_idbankupln=getbankdlaklienta(NEW.fm_idcentrali,NEW.k_idklienta,NEW.tmg_idmagazynu,1);
  ELSE
   NEW.bk_idbankupln=NEW.bk_idbankuwal;
  END IF;
 END IF;
 
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END;
$$;
