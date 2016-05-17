CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 ineid INT;
BEGIN

 ineid=(SELECT ine_id FROM tg_inwelems WHERE tr_idtrans=idtrans AND mm_idmiejsca IS NOT DISTINCT FROM idmiejsca FOR UPDATE);
 IF (ineid IS NULL) THEN
  PERFORM gm.inwwm_recalccstancalc(idtrans,idmiejsca);
 END IF;
 
 RETURN gm.inwwm_addinwentaryzacjamm(idtrans,idmiejsca,idpartiipz,deltailoscf,iloscfcomp);
END;
$$;
