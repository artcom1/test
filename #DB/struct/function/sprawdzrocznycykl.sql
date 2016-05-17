CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
	dataod ALIAS FOR $1; --przedzial czasu zadany filtrami
	datado ALIAS FOR $2; --przedzial czasu zadany filtrami

	datar ALIAS FOR $3; --ramy czasowe cyklicznosci zdarzenia
	dataz ALIAS FOR $4; --ramy czasowe cyklicznosci zdarzenia

	data DATE;
	dayr INT;
	monr INT;
BEGIN
	IF (dataz < dataod) THEN
		RETURN FALSE;
	END IF;

	IF (datar >= dataod AND datar <= datado) THEN
		RETURN TRUE;
	END IF;

	data := setYear(datar, date_part('year', dataod)::int);
	IF (data < dataod) THEN
		data := data + '+1 year'::interval;
	END IF;
	
	IF (data > dataz) THEN
		RETURN FALSE;
	END IF;

	IF (data >= dataod AND data <= datado) THEN
		RETURN TRUE;
	END IF;

	RETURN FALSE;
END;
$_$;
