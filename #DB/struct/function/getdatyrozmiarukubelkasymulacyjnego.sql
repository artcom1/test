CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _rk_idrozmiaru ALIAS FOR $1;
 _ksym_rok      ALIAS FOR $2;
 _ksym_poczatek ALIAS FOR $3;
 _clip_end      ALIAS FOR $4;
 rozmiarrec RECORD;
 typrozmiaru INTEGER:=0;
 rozmiar INTEGER:=0;
 jednostkowo INTEGER;
 lens_to_check INTEGER;
 max_data TIMESTAMP;
BEGIN
	SELECT rk_typrozmiaru,rk_rozmiar INTO rozmiarrec FROM ts_rozmiarykubelkow WHERE rk_idrozmiaru=_rk_idrozmiaru;
	typrozmiaru = rozmiarrec.rk_typrozmiaru;
	rozmiar = rozmiarrec.rk_rozmiar;

	IF (typrozmiaru=0 OR typrozmiaru>3 OR rozmiar=0) THEN
		RETURN;
	END IF;

	IF ((_ksym_poczatek < 1) OR (_ksym_poczatek > (SELECT getMaxOkresKubelkaSymulacyjnego(_rk_idrozmiaru, _ksym_rok)))) THEN
		RETURN;
	END IF;
	
	jednostkowo = ((_ksym_poczatek-1) * rozmiar)+1;
	IF (typrozmiaru=1) THEN --dzienny
		dataod = (SELECT to_timestamp(_ksym_rok::text||'-'||jednostkowo::text, 'YYYY-DDD'));
	ELSIF (typrozmiaru=2) THEN --tygodniowy
		dataod = (SELECT to_timestamp(_ksym_rok::text||'-'||jednostkowo::text, 'IYYY-IW'));
	ELSIF (typrozmiaru=3) THEN --miesieczny
		dataod = (SELECT to_timestamp(_ksym_rok::text||'-'||jednostkowo::text||'-01', 'YYYY-MM-DD'));
	END IF;

	IF (_clip_end) THEN
		lens_to_check = rozmiar;
		max_data = (SELECT getDataOdKubelkaSymulacyjnego(_rk_idrozmiaru, _ksym_rok+1, 1));
		IF (max_data IS NULL) THEN
			RETURN;
		END IF;
	ELSE
		lens_to_check = 1;
	END IF;

	jednostkowo = (_ksym_poczatek * rozmiar)+1;
	FOR i IN 0..(lens_to_check-1) LOOP
		IF (typrozmiaru=1) THEN --dzienny
			datado = (SELECT to_timestamp(_ksym_rok::text||'-'||jednostkowo::text, 'YYYY-DDD'));
		ELSIF (typrozmiaru=2) THEN --tygodniowy
			datado = (SELECT to_timestamp(_ksym_rok::text||'-'||jednostkowo::text, 'IYYY-IW'));
		ELSIF (typrozmiaru=3) THEN --miesieczny
			datado = (SELECT to_timestamp(_ksym_rok::text||'-'||jednostkowo::text||'-01', 'YYYY-MM-DD'));
		END IF;

		IF (datado <= max_data) THEN
			EXIT;
		END IF;

		jednostkowo = jednostkowo-1;
	END LOOP;
END;
$_$;
