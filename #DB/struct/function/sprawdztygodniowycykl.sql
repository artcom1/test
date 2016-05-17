CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
	dataod ALIAS FOR $1; --przedzial czasu zadany filtrami
	datado ALIAS FOR $2; --przedzial czasu zadany filtrami

	datar ALIAS FOR $3; --ramy czasowe cyklicznosci zdarzenia
	dataz ALIAS FOR $4; --ramy czasowe cyklicznosci zdarzenia

	data DATE;

	weeks INT;
BEGIN
	IF (dataz < dataod OR datar > datado) THEN
		RETURN FALSE;
	END IF;

	IF (datar >= dataod AND datar <= datado) THEN
		RETURN TRUE;
	END IF;

	data := datar;
	weeks := floor((dataod - data)::int / 7);
	data := data + weeks * ('+1 week')::interval;

	IF (data >= dataod AND data <= dataz) THEN
		RETURN TRUE;
	END IF;

	data := data + '+1 week'::interval;
	IF (data >= dataod AND data <= dataz AND data <= datado) THEN
		RETURN TRUE;
	END IF;

	RETURN FALSE;
END;
$_$;
