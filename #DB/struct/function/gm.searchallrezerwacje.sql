CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtowmag ALIAS FOR $1;
 _idpartiipz ALIAS FOR $2;
 ilemax    NUMERIC;
 ruch_data tg_ruchy;
BEGIN

 ----RAISE NOTICE 'Mam id % ',_idpartiipz;

 IF (COALESCE(vendo.getTParam('BLOCKREZSEARCH'),'0')<>'0') THEN
  RETURN 0;
 END IF;

--- RAISE NOTICE 'Szukam wszystkich partii % %',_idtowmag,_idpartiipz;

 ilemax=(SELECT ttm_stan-ttm_rezerwacja FROM tg_towmag WHERE ttm_idtowmag=_idtowmag FOR UPDATE);

 ---RAISE NOTICE 'Jest wolne % ',ilemax;

 IF (ilemax<=0) THEN
  RETURN 0;
 END IF;


 ruch_data.ttm_idtowmag=_idtowmag;
 ruch_data.ttw_idtowaru=(SELECT ttw_idtowaru FROM tg_towmag WHERE ttm_idtowmag=_idtowmag);
 ruch_data.prt_idpartiipz=_idpartiipz;


 RETURN gm.searchForRezerwacje(ilemax,ruch_data);
END;
$_$;
