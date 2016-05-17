CREATE OR REPLACE FUNCTION 
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
     
 SELECT min(rme_idindextab) AS low, max(rme_idindextab) AS upp INTO _rec_old FROM tg_rozmrodzajeelems WHERE rmr_idrodzaju=rmr_idrodzajuOld;
 SELECT min(rme_idindextab) AS low, max(rme_idindextab) AS upp INTO _rec_new FROM tg_rozmrodzajeelems WHERE rmr_idrodzaju=rmr_idrodzajuNew;
 
 RAISE NOTICE '[%:%] <-> [%:%]', _rec_old.low, _rec_old.upp, _rec_new.low, _rec_new.upp;
 
 FOR _rec_tmp IN
 SELECT 
 oldr.rme_idindextab AS iold, newr.rme_idindextab AS inew 
 FROM tg_rozmrodzajeelems AS oldr
 LEFT JOIN tg_rozmrodzajeelems AS newr ON (oldr.rme_kod=newr.rme_kod)
 WHERE oldr.rmr_idrodzaju=rmr_idrodzajuOld AND newr.rmr_idrodzaju=rmr_idrodzajuNew
 LOOP
  _arr_tmp[_rec_tmp.inew]=_rec_tmp.iold;
 END LOOP;
 
 RAISE NOTICE 'Przed: %', _arr_tmp;
 
 _arr_tmp=array_normalize(array_create(_rec_new.low, _rec_new.upp, 1),_arr_tmp); 
 RAISE NOTICE 'Po: %', _arr_tmp;
 
 RETURN _arr_tmp;
END;
$$;
