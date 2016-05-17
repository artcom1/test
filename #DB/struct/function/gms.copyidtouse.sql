CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
 ---Ruchy WZet
 INSERT INTO gms.tm_idtouse
  (sc_simid,ttm_idtowmag,rc_idruchuwz)
 SELECT simid,ttm_idtowmag,dstid 
 FROM gms.tm_idtouse
 WHERE sc_id=vendo.tv_mysessionpid() AND sc_simid=simid AND rc_idruchuwz=srcid;

 ---Ruchy lekkie
 INSERT INTO gms.tm_idtouse
  (sc_simid,ttm_idtowmag,rc_idruchurezl)
 SELECT simid,ttm_idtowmag,dstid 
 FROM gms.tm_idtouse
 WHERE sc_id=vendo.tv_mysessionpid() AND sc_simid=simid AND rc_idruchurezl=srcid;

 ---Ruchy ciezkie
 INSERT INTO gms.tm_idtouse
  (sc_simid,ttm_idtowmag,rc_idruchurezc)
 SELECT simid,ttm_idtowmag,dstid 
 FROM gms.tm_idtouse
 WHERE sc_id=vendo.tv_mysessionpid() AND sc_simid=simid AND rc_idruchurezc=srcid;

 ---Ruchy WZet inne
 INSERT INTO gms.tm_idtouse
  (sc_simid,ttm_idtowmag,rc_idruchuwz_touse)
 SELECT simid,ttm_idtowmag,dstid 
 FROM gms.tm_idtouse
 WHERE sc_id=vendo.tv_mysessionpid() AND sc_simid=simid AND rc_idruchuwz_touse=srcid;

 RETURN TRUE;
END;
$$;
