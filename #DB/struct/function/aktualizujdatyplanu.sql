CREATE FUNCTION aktualizujdatyplanu(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _typAkt ALIAS FOR $1;
 _idref ALIAS FOR $2; 
 rec RECORD;
BEGIN
---------------------------------------------------------------
 -- _typAkt=1 - aktualizuje dane wg dzieci planu
 -- _typAkt=2 - aktualizuje dane wg KKW
 ---------------------------------------------------------------
 
 -- _typAkt=1 - aktualizuje dane wg dzieci planu
 IF (_typAkt=1) THEN
  SELECT 
  min(pz_dataod) AS dataod, 
  max(pz_datado) AS datado 
  INTO rec FROM tg_planzlecenia 
  WHERE pz_idref=_idref;
    
  IF (rec.dataod IS NOT NULL OR rec.datado IS NOT NULL) THEN
   UPDATE tg_planzlecenia SET pz_dataod=COALESCE(rec.dataod,pz_dataod), pz_datado=COALESCE(rec.datado,pz_datado) WHERE pz_idplanu=_idref;
   RETURN 1;
  END IF;
 END IF;
  
 -- _typAkt=2 - aktualizuje dane wg KKW
 IF (_typAkt=2) THEN
  SELECT 
  min(CASE WHEN kwh_datazakonczenianodow IS NOT NULL THEN kwh_datarozp ELSE COALESCE(kwh_dataplanstart,kwh_datarozp) END) AS dataod,
  max(COALESCE(kwh_datazakonczenianodow,kwh_dataplanstop,kwh_datazak)) AS datado
  INTO rec FROM tr_kkwhead 
  WHERE pz_idplanu=_idref;
    
  IF (rec.dataod IS NOT NULL OR rec.datado IS NOT NULL) THEN
   UPDATE tg_planzlecenia SET pz_dataod=COALESCE(rec.dataod,pz_dataod), pz_datado=COALESCE(rec.datado,pz_datado) WHERE pz_idplanu=_idref;
   RETURN 2;
  END IF;
 END IF; 
   
 RETURN 0;
END;
$_$;
