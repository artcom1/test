CREATE FUNCTION przeliczenie_tech_rozm(_ttw_idtowaru integer, rmr_idrodzajuold integer, rmr_idrodzajunew integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
 _rec_old RECORD;
 _rec_new RECORD; 
 _rec_tmp RECORD;
 
 _arr_tmp INT[]; 
BEGIN

 IF (rmr_idrodzajuOld IS NULL OR rmr_idrodzajuOld=rmr_idrodzajuNew OR rmr_idrodzajuNew IS NULL) THEN
  RETURN NULL;
 END IF;
     
 _arr_tmp=getTranslateArrayByRozmiary(rmr_idrodzajuOld, rmr_idrodzajuNew); 
 IF (_arr_tmp IS NULL) THEN
  RETURN NULL;
 END IF;
  
 UPDATE tr_rrozchodu
 SET trr_rozmiarwyst=array_translate(trr_rozmiarwyst,_arr_tmp)
 WHERE 
 th_idtechnologii IN (SELECT th_idtechnologii FROM tr_technologie WHERE ttw_idtowaru=_ttw_idtowaru);
 
 UPDATE tr_technologie
 SET th_flaga=(CASE WHEN (th_flaga&(1<<12))=(1<<12) THEN th_flaga&(~(1<<12)) ELSE th_flaga|(1<<12) END)
 WHERE ttw_idtowaru=_ttw_idtowaru;
  
 RETURN _ttw_idtowaru;
END;
$$;
