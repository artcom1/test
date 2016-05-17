CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _wz1          ALIAS FOR $1;  --- Partia dotychczasowa (istniejaca)
 _wz2          ALIAS FOR $2;  --- Partia nowa
 _whereparams ALIAS FOR $3;
BEGIN
 ---Porownaj wplywy
 IF (_wz1.prt_wplyw>=0) OR (_wz2.prt_wplyw>=0) THEN
  RETURN FALSE;
 END IF;
 ---ID Towaru---------------------------------------------------------------------------------
 IF (_wz1.ttw_idtowaru<>_wz2.ttw_idtowaru) THEN
  RETURN FALSE;
 END IF;
 
 IF (_wz1.prt_idref IS DISTINCT FROM _wz2.prt_idref) THEN
  RETURN FALSE;
 END IF;
 
 ---HashCode----------------------------------------------------------------------------------
 IF (_wz1.prt_hashcode IS NOT NULL) AND (_wz2.prt_hashcode IS NOT NULL) THEN
  IF (NOT (_wz1.prt_hashcode==_wz2.prt_hashcode)) THEN
   RETURN FALSE;
  END IF;
 END IF;
 ---ID Klienta--------------------------------------------------------------------------------
 IF (_wz1.k_idklienta IS NOT NULL) AND (_wz2.k_idklienta IS NOT NULL) THEN
  IF (_wz1.k_idklienta<>_wz2.k_idklienta) THEN
   RETURN FALSE;
  END IF;
 END IF;
 ---ID Zlecenia-------------------------------------------------------------------------------
 IF (_wz1.zl_idzlecenia IS NOT NULL) AND (_wz2.zl_idzlecenia IS NOT NULL) THEN
  IF (_wz1.zl_idzlecenia<>_wz2.zl_idzlecenia) THEN
   RETURN FALSE;
  END IF;
 END IF;
 ---------------------------------------------------------------------------------------------
 IF (_wz1.prt_datawazn IS NOT NULL) AND (_wz2.prt_datawazn IS NOT NULL) THEN
  CASE ((_whereparams>>3)&7)
   WHEN 0 THEN --- =
    IF (_wz1.prt_datawazn<>_wz2.prt_datawazn) THEN RETURN FALSE; END IF;
   WHEN 1 THEN  --- <
    IF (NOT (_wz2.prt_datawazn<=_wz1.prt_datawazn)) THEN RETURN FALSE; END IF;
   WHEN 2 THEN  --- >
    IF (NOT (_wz2.prt_datawazn>=_wz1.prt_datawazn)) THEN RETURN FALSE; END IF;
   WHEN 3 THEN --- <=
    IF (NOT (_wz2.prt_datawazn<=_wz1.prt_datawazn)) THEN RETURN FALSE; END IF;
   WHEN 4 THEN  --- >=
    IF (NOT (_wz2.prt_datawazn>=_wz1.prt_datawazn)) THEN RETURN FALSE; END IF;
  END CASE;
 END IF;
 ---------------------------------------------------------------------------------------------
 IF (_wz1.prt_serialno IS NOT NULL) AND (_wz2.prt_serialno IS NOT NULL) THEN
  CASE ((_whereparams>>0)&7)
   WHEN 0 THEN 
    IF (_wz1.prt_serialno<>_wz2.prt_serialno) THEN RETURN FALSE; END IF;
   WHEN 1 THEN 
    IF (_wz1.prt_serialno NOT ILIKE '%'||_wz2.prt_serialno||'%') THEN RETURN FALSE; END IF;
   WHEN 2 THEN 
    ---Partia dotychczasowa (lewa) musi byc szersza jak prawa
    IF (_wz1.prt_serialno NOT ILIKE _wz2.prt_serialno||'%') THEN 
     ---RAISE EXCEPTION 'Falsz % i % ',_wz1.prt_serialno,_wz2.prt_serialno;
     RETURN FALSE; 
    END IF;
   WHEN 3 THEN 
    IF (_wz1.prt_serialno<>_wz2.prt_serialno) THEN RETURN FALSE; END IF;
    ---RAISE NOTICE 'Prawdziwe % i % ',_wz1.prt_serialno,_wz2.prt_serialno;
  END CASE;
 END IF;
 
 ---------------------------------------------------------------------------------------------
 IF (_wz1.prt_inkj IS NOT NULL) AND (_wz2.prt_inkj IS NOT NULL) THEN
  IF (_wz1.prt_inkj!=_wz2.prt_inkj) THEN
   RETURN 0;
  END IF;
 END IF;
 ---------------------------------------------------------------------------------------------
 IF (_wz1.rmp_idsposobu IS DISTINCT FROM _wz2.rmp_idsposobu) THEN
  ---Sposoby pakowania musza sie zgadzac
  RETURN 0;
 END IF;

 RETURN TRUE;
END;
$_$;
