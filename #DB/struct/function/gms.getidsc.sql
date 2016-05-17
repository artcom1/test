CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 ret INT;
BEGIN

 ret=(SELECT sc_id FROM gms.tm_simcoll WHERE sc_sid=vendo.tv_mysessionpid() AND sc_simid=simid AND rc_idruchupz=idruchupz);
 
 IF (ret IS NOT NULL) THEN 
  RETURN ret;
 END IF;

 RETURN gms.initSC(simid,NULL,idruchupz);
END;
$$;
