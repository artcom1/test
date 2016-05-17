CREATE FUNCTION dodajbackordernodrec(integer, integer, numeric, integer, integer, date, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelemu      ALIAS FOR $1;
 _idtowmag     ALIAS FOR $2;
 _ilosc        ALIAS FOR $3;
 _powod        ALIAS FOR $4;
 _flag         ALIAS FOR $5;
 _data         ALIAS FOR $6;
 _zlecenie     ALIAS FOR $7;
 id            INT;
BEGIN

 IF (_idtowmag IS NULL) THEN RETURN NULL; END IF;

 id=(SELECT bo_idbackord FROM tg_backorder WHERE (knr_idelemusrc=_idelemu) AND (ttm_idtowmag=_idtowmag) AND (bo_powod=_powod) AND (bo_flaga&1=_flag));
 IF (id IS NULL) THEN
  IF (_ilosc=0) THEN RETURN NULL; END IF;  
  INSERT INTO tg_backorder
    (ttm_idtowmag,bo_iloscf,bo_powod,knr_idelemusrc,bo_flaga, bo_data, zl_idzlecenia)
  VALUES
    (_idtowmag,_ilosc,_powod,_idelemu,_flag,_data,_zlecenie);
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


--
--

CREATE FUNCTION dodajbackordernodrec(integer, integer, numeric, integer, integer, date, integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelemu      ALIAS FOR $1;
 _idtowmag     ALIAS FOR $2;
 _ilosc        ALIAS FOR $3;
 _powod        ALIAS FOR $4;
 _flag         ALIAS FOR $5;
 _data         ALIAS FOR $6;
 _zlecenie     ALIAS FOR $7;
 _flag_knr     ALIAS FOR $8;
 _idmagazynu   ALIAS FOR $9;
 id            INT; 
 _rec          RECORD;
 ileroz        INT:=0;
BEGIN 
 IF ((_flag_knr&((1<<12)|(1<<15)))=(1<<12) AND _idmagazynu IS NOT NULL) THEN -- Rozmiarowka
  RETURN 1;
 END IF;
 
 IF (_idtowmag IS NULL) THEN RETURN NULL; END IF;

 id=(SELECT bo_idbackord FROM tg_backorder WHERE (knr_idelemusrc=_idelemu) AND (ttm_idtowmag=_idtowmag) AND (bo_powod=_powod) AND (bo_flaga&1=_flag));
 IF (id IS NULL) THEN
  IF (NullZero(_ilosc)=0) THEN 
   RETURN NULL; 
  END IF;  
  INSERT INTO tg_backorder
    (ttm_idtowmag,bo_iloscf,bo_powod,knr_idelemusrc,bo_flaga, bo_data, zl_idzlecenia)
  VALUES
    (_idtowmag,_ilosc,_powod,_idelemu,_flag,_data,_zlecenie);
   RETURN (SELECT currval('tg_backorder_s'));
 ELSE
  IF (NullZero(_ilosc)=0) THEN
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
