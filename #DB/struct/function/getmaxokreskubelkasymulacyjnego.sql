CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _rk_idrozmiaru ALIAS FOR $1;
 _ksym_rok      ALIAS FOR $2;
 
 typrozmiaru INTEGER:=0;
 rozmiar INTEGER:=0;
 wynik INTEGER:=0;
 rozmiarrec RECORD;
 jednostkowe INTEGER:=0;
BEGIN
	SELECT rk_typrozmiaru,rk_rozmiar INTO rozmiarrec FROM ts_rozmiarykubelkow WHERE rk_idrozmiaru=_rk_idrozmiaru;
	typrozmiaru = rozmiarrec.rk_typrozmiaru;
	rozmiar = rozmiarrec.rk_rozmiar;

	IF (typrozmiaru=0 OR rozmiar=0) THEN
		RETURN 0;
	END IF;

	IF (typrozmiaru=1) THEN --dzienny
		jednostkowe = (SELECT to_date((_ksym_rok+1)::text, 'YYYY')-to_date(_ksym_rok::text, 'YYYY'));
	ELSIF (typrozmiaru=2) THEN --tygodniowy
		jednostkowe = (SELECT EXTRACT(week FROM (SELECT to_timestamp((_ksym_rok::text)||('-12-28'), 'YYYY-MM-DD'))));
	ELSIF (typrozmiaru=3) THEN --miesieczny
		jednostkowe=12;
	END IF;

	IF (jednostkowe=0) THEN
		RETURN 0;
	END IF;

	wynik = jednostkowe/rozmiar;
	IF (wynik*rozmiar<jednostkowe) THEN
		wynik = wynik+1;
	END IF;

	RETURN wynik;
END;
$_$;
