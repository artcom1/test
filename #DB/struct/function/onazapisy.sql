CREATE FUNCTION onazapisy() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

IF (TG_OP = 'INSERT') THEN
 PERFORM doSkojTrans(NEW.tr_idtrans_wkh,1,0,1);
END IF;

IF (TG_OP = 'DELETE') THEN
 PERFORM doSkojTrans(OLD.tr_idtrans_wkh,-1,0,1);
END IF;
 

 IF (TG_OP='UPDATE') THEN

  IF (OLD.zk_flaga&9)<>(NEW.zk_flaga&9) OR 
     (NEW.zk_fullnumer<>OLD.zk_fullnumer) OR 
     (NEW.mn_miesiac<>OLD.mn_miesiac) OR
     (NEW.zk_datadok<>OLD.zk_datadok)
  THEN
   --Zrob update elementow tak zeby przeniosl sobie flage
   UPDATE kh_zapisyelem SET mc_miesiac=NEW.mn_miesiac,zp_datadok=NEW.zk_datadok WHERE zk_idzapisu=NEW.zk_idzapisu;
  END IF;

  IF (nullZero(NEW.tr_idtrans_wkh)!=nullZero(OLD.tr_idtrans_wkh)) THEN
   PERFORM doSkojTrans(OLD.tr_idtrans_wkh,-1,0,1);
   PERFORM doSkojTrans(NEW.tr_idtrans_wkh,1,0,1);
  END IF;

 END IF;
 
 IF (TG_OP = 'DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
