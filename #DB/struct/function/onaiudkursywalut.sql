CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 r RECORD;
BEGIN

 IF (TG_OP='DELETE') THEN
  IF (OLD.kw_islast=TRUE) THEN 
   SELECT kw_idkursu,kw_islast,wl_idwaluty,tw_idtabeli INTO r FROM tg_kursywalut AS kw WHERE kw.wl_idwaluty=OLD.wl_idwaluty AND kw.tw_idtabeli=OLD.tw_idtabeli ORDER BY kw_data DESC LIMIT 1;
  END IF;
 ELSE
  SELECT INTO r kw_idkursu,kw_islast,wl_idwaluty,tw_idtabeli FROM tg_kursywalut AS kw WHERE kw.wl_idwaluty=NEW.wl_idwaluty AND kw.tw_idtabeli=NEW.tw_idtabeli ORDER BY kw_data DESC LIMIT 1;
 END IF;

 IF (FOUND) THEN
  IF (r.kw_islast=FALSE) THEN
   UPDATE tg_kursywalut SET kw_islast=FALSE WHERE kw_islast=TRUE AND tw_idtabeli=r.tw_idtabeli AND wl_idwaluty=r.wl_idwaluty;
   UPDATE tg_kursywalut SET kw_islast=TRUE WHERE kw_idkursu=r.kw_idkursu AND kw_islast=FALSE;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END
$$;
