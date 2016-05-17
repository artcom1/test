CREATE FUNCTION dodajbackorderkkw(integer, integer, numeric, integer, date, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idkkw        ALIAS FOR $1;
 _idtowmag     ALIAS FOR $2;
 _ilosc        ALIAS FOR $3;
 _powod        ALIAS FOR $4;
 _data         ALIAS FOR $5;
 _zlecenie     ALIAS FOR $6;
 id            INT;
 flag          INT:=1;
BEGIN

 IF (_idtowmag IS NULL) THEN RETURN NULL; END IF;

 id=(SELECT bo_idbackord FROM tg_backorder WHERE (kwh_idheadusrc=_idkkw) AND (ttm_idtowmag=_idtowmag) AND (bo_powod=_powod) AND (bo_flaga&1=flag));
 IF (id IS NULL) THEN
  IF (_ilosc=0) THEN RETURN NULL; END IF;  
  INSERT INTO tg_backorder
    (ttm_idtowmag,bo_iloscf,bo_powod,kwh_idheadusrc,bo_flaga,bo_data,zl_idzlecenia)
  VALUES
    (_idtowmag,_ilosc,_powod,_idkkw,flag,_data,_zlecenie);
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

CREATE FUNCTION dodajbackorderkkw(integer, integer, numeric, integer, date, integer, integer[], integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idkkw      ALIAS FOR $1;
 _idtowmag   ALIAS FOR $2;
 _ilosc      ALIAS FOR $3;
 _powod      ALIAS FOR $4;
 _data       ALIAS FOR $5;
 _zlecenie   ALIAS FOR $6;
 _towary     ALIAS FOR $7;
 _magazyn    ALIAS FOR $8;
 id          INT;
 flag        INT:=1;
 _rec        RECORD;
 
 _iloscoczek NUMERIC;
 _iloscwmag  NUMERIC;
BEGIN
 
 IF (_towary IS NOT NULL AND _magazyn IS NOT NULL) THEN -- Rozmiarowka
  FOR _rec IN 
  SELECT
  kwh_towary,
  sum(kwhr_ilosciwkart*kwhr_ilosckart) AS _il_oczek,
  sum(kwhr_iloscwmag_arr) AS _il_wmag
  FROM
  (
   SELECT
   UNNEST(kwh_towary) AS kwh_towary,
   UNNEST(array_normalize(kwh_towary, kwhr_ilosciwkart)) AS kwhr_ilosciwkart,
   UNNEST(array_normalize(kwh_towary, kwhr_iloscwmag_arr)) AS kwhr_iloscwmag_arr,
   kwhr_ilosckart   
   FROM tr_kkwheadrozm AS rozm JOIN tr_kkwhead AS head ON (kwhr_kwh_idheadu=kwh_idheadu)
   WHERE kwhr_kwh_idheadu=373
  ) AS a 
  WHERE kwhr_ilosciwkart>0
  GROUP BY kwh_towary
  LOOP
   RAISE LOG ' DEBUG: dodajbackorderkkw: kwh_towary=% _il_oczek=% _il_wmag=%', _rec.kwh_towary, _rec._il_oczek, _rec._il_wmag;
   IF (_ilosc=0) THEN    
    PERFORM dodajBackOrderKKW(_idkkw,gettowmag(_rec.kwh_towary,_magazyn,TRUE),0,_powod,_data,_zlecenie,NULL,0);
   ELSE
    PERFORM dodajBackOrderKKW(_idkkw,gettowmag(_rec.kwh_towary,_magazyn,TRUE),max(0,(_rec._il_oczek-_rec._il_wmag)),_powod,_data,_zlecenie,NULL,0);
   END IF;
  END LOOP;
  RETURN 1;
 END IF;

 IF (_idtowmag IS NULL) THEN RETURN NULL; END IF;

 id=(SELECT bo_idbackord FROM tg_backorder WHERE (kwh_idheadusrc=_idkkw) AND (ttm_idtowmag=_idtowmag) AND (bo_powod=_powod) AND (bo_flaga&1=flag));
 IF (id IS NULL) THEN
  IF (_ilosc=0) THEN RETURN NULL; END IF;  
  INSERT INTO tg_backorder
    (ttm_idtowmag,bo_iloscf,bo_powod,kwh_idheadusrc,bo_flaga,bo_data,zl_idzlecenia)
  VALUES
    (_idtowmag,_ilosc,_powod,_idkkw,flag,_data,_zlecenie);
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
