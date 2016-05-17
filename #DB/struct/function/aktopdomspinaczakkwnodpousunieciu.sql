CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _spo_idspinacza ALIAS FOR $1;
 _kwe_idelemu  ALIAS FOR $2;
 _kwe_idelemudef INT;
BEGIN

 _kwe_idelemudef=(SELECT kwe_idelemudef FROM tr_spinaczoperacji WHERE spo_idspinacza=_spo_idspinacza);
 
 IF (_kwe_idelemudef=_kwe_idelemu OR _kwe_idelemudef IS NULL) THEN -- Usunalem ze spinacza operacje domyslna
  UPDATE tr_spinaczoperacji
  SET kwe_idelemudef=(SELECT kwe_idelemu FROM tr_kkwnod WHERE spo_idspinacza=_spo_idspinacza AND kwe_idelemu<>_kwe_idelemu ORDER BY kwe_idelemu LIMIT 1)
  WHERE spo_idspinacza=_spo_idspinacza; 
 END IF;
 
 RETURN TRUE;
END
$_$;
