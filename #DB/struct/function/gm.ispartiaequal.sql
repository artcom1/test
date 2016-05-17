CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _pz          ALIAS FOR $1;
 _wz          ALIAS FOR $2;
 _whereparams ALIAS FOR $3;
 _wzpartia    ALIAS FOR $4;
BEGIN
 ---Porownaj wplywy
 IF (_pz.prt_wplyw<=0) OR (_wz.prt_wplyw>=0) THEN
  RETURN FALSE;
 END IF;
 ---ID Towaru---------------------------------------------------------------------------------
 IF (_pz.ttw_idtowaru<>_wz.ttw_idtowaru) THEN
  RETURN FALSE;
 END IF;
 ---Podana dokladna partia--------------------------------------------------------------------
 IF (_wzpartia IS NOT NULL AND (_wz.prt_idpartii<>_wzpartia)) THEN
  RETURN FALSE;
 END IF;

 RETURN (gm.comparePartie(_pz,_wz,_whereparams)>0);
END;
$_$;
