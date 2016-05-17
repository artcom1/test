CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelemsrc    ALIAS FOR $1;
 _idtowmag     ALIAS FOR $2;
 _ilosc        ALIAS FOR $3;
 _isprzychod   ALIAS FOR $4;
 _powod        ALIAS FOR $5;
 _zrezerwacja  ALIAS FOR $6;
 _data         ALIAS FOR $7;
 _zlecenie     ALIAS FOR $8;
 id            INT:=NULL;
 flag          INT:=0;
BEGIN

 IF (_isprzychod) THEN flag=1; END IF;

 id=(SELECT bo_idbackord FROM tg_backorder WHERE (tel_idelemsrc=_idelemsrc) AND (ttm_idtowmag=_idtowmag) AND (bo_powod=_powod) AND (bo_flaga&1=flag));
 IF (id IS NULL) THEN
  IF (_ilosc=0) THEN RETURN NULL; END IF;  
  INSERT INTO tg_backorder
    (ttm_idtowmag,bo_iloscf,bo_powod,tel_idelemsrc,bo_flaga, bo_data,zl_idzlecenia)
  VALUES
    (_idtowmag,_ilosc,_powod,_idelemsrc,flag,_data,_zlecenie);
  id=(SELECT currval('tg_backorder_s'));
 ELSE
  IF (_ilosc=0) THEN
   DELETE FROM tg_backorder WHERE bo_idbackord=id;
  ELSE
   UPDATE tg_backorder SET bo_iloscf=_ilosc, bo_data=_data,zl_idzlecenia=_zlecenie WHERE (bo_idbackord=id) AND (bo_iloscf<>_ilosc OR bo_data<>_data OR zl_idzlecenia<>_zlecenie);
  END IF;
 END IF;

 RETURN id;
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 id            INT:=NULL;
 flag          INT:=0;
BEGIN
 _new2flaga=COALESCE(_new2flaga,0);
 
 IF (gmr.getznaczeniezestawu(_new2flaga)=1) AND (gmr.gettypzestawu(_new2flaga)=3) THEN
  RETURN NULL;
 END IF;
 

 IF (_isprzychod) THEN flag=1; END IF;

 id=(SELECT bo_idbackord FROM tg_backorder WHERE (tel_idelemsrc=_idelemsrc) AND (ttm_idtowmag=_idtowmag) AND (bo_powod=_powod) AND (bo_flaga&1=flag));
 IF (id IS NULL) THEN
  IF (_ilosc=0) THEN RETURN NULL; END IF;  
  INSERT INTO tg_backorder
    (ttm_idtowmag,bo_iloscf,bo_powod,tel_idelemsrc,bo_flaga, bo_data,zl_idzlecenia)
  VALUES
    (_idtowmag,_ilosc,_powod,_idelemsrc,flag,_data,_zlecenie);
  id=(SELECT currval('tg_backorder_s'));
 ELSE
  IF (_ilosc=0) THEN
   DELETE FROM tg_backorder WHERE bo_idbackord=id;
  ELSE
   UPDATE tg_backorder SET bo_iloscf=_ilosc, bo_data=_data,zl_idzlecenia=_zlecenie WHERE (bo_idbackord=id) AND (bo_iloscf<>_ilosc OR bo_data<>_data OR zl_idzlecenia<>_zlecenie);
  END IF;
 END IF;

 RETURN id;
END;
$$;
