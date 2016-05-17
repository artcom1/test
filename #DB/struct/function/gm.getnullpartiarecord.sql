CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 pap        tg_partie;
BEGIN
 pap.ttw_idtowaru=idtowaru;
 IF (pap.ttw_idtowaru IS NULL) THEN
  pap.ttw_idtowaru=(SELECT ttm_idtowmag FROM tg_towmag WHERE ttm_idtowmag=idtowmag);
 END IF;
 IF (wplyw<0) THEN
  pap.prt_wplyw=-2;
 ELSE
  pap.prt_wplyw=1;
 END IF;

 RETURN pap;
END;
$$;
