CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 DELETE FROM gms.tm_touse WHERE sc_sid=vendo.tv_mysessionpid() AND sc_simid=simid AND rc_idruchuwz IS NOT NULL;
 DELETE FROM gms.tm_simwz WHERE sc_id IN (SELECT sc_id FROM gms.tm_simcoll WHERE sc_sid=vendo.tv_mysessionpid() AND sc_simid=simid);

 RETURN TRUE;
END;
$$;
