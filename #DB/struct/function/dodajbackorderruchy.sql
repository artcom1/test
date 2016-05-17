CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idruchusrc   ALIAS FOR $1;
 _idtowmag     ALIAS FOR $2;
 _ilosc        ALIAS FOR $3;
 _powod        ALIAS FOR $4;
 _data         ALIAS FOR $5;
 _zlecenie     ALIAS FOR $6;
 id            INT;
 flag          INT:=0;
BEGIN

 id=(SELECT bo_idbackord FROM tg_backorder WHERE (rc_idruchusrc=_idruchusrc) AND (ttm_idtowmag=_idtowmag) AND (bo_powod=_powod) AND (bo_flaga&1=flag));
 IF (id IS NULL) THEN
  IF (_ilosc=0) THEN RETURN NULL; END IF;  
  INSERT INTO tg_backorder
    (ttm_idtowmag,bo_iloscf,bo_powod,rc_idruchusrc,bo_flaga,bo_data, zl_idzlecenia)
  VALUES
    (_idtowmag,_ilosc,_powod,_idruchusrc,flag,_data,_zlecenie);
   RETURN (SELECT currval('tg_backorder_s'));
 ELSE
  IF (_ilosc=0) THEN
   DELETE FROM tg_backorder WHERE bo_idbackord=id;
   RETURN NULL;
  ELSE
   UPDATE tg_backorder SET bo_iloscf=_ilosc, bo_data=_data, zl_idzlecenia=_zlecenie WHERE (bo_idbackord=id) AND (bo_iloscf<>_ilosc OR bo_data<>_data OR zl_idzlecenia<>_zlecenie);
   RETURN id;
  END IF;
 END IF;

 RETURN NULL;
END;
$_$;
