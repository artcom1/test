CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _rk_idrozmiaru ALIAS FOR $1;
 _ksym_rok      ALIAS FOR $2;
 
 maxokres INTEGER;
BEGIN
	maxokres = (SELECT getMaxOkresKubelkaSymulacyjnego(_rk_idrozmiaru, _ksym_rok));
	
	FOR i IN 1..maxokres LOOP
		okres = i;
		data_od = (SELECT getDataOdKubelkaSymulacyjnego(_rk_idrozmiaru, _ksym_rok, i));
		data_do = (SELECT getDataDoKubelkaSymulacyjnego(_rk_idrozmiaru, _ksym_rok, i));
		RETURN NEXT;
	END LOOP;
END;
$_$;
