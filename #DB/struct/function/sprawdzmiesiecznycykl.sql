CREATE FUNCTION sprawdzmiesiecznycykl(date, date, date, date) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
	dataod ALIAS FOR $1; --przedzial czasu zadany filtrami
	datado ALIAS FOR $2; --przedzial czasu zadany filtrami

	datar ALIAS FOR $3; --ramy czasowe cyklicznosci zdarzenia
	dataz ALIAS FOR $4; --ramy czasowe cyklicznosci zdarzenia

	data DATE;
	monc INT;
BEGIN
	IF (dataz < dataod OR datar > datado) THEN
		RETURN FALSE;
	END IF;

	IF (datar >= dataod AND datar <= datado) THEN
		RETURN TRUE;
	END IF;

	monc := getRoznicaLat(dataod, datar) * 12;
	data := datar + monc * '1 month'::interval;

	IF (date(data) < dataod) THEN
		WHILE (date(data) < dataod) LOOP
			monc := monc + 1;
			data := datar + monc * '+1 month'::interval;
		END LOOP;
	ELSE
		WHILE ((date(data) - '1 month'::interval) > dataod) LOOP
			monc := monc - 1;
			data := datar + monc * '+1 month'::interval;
		END LOOP;		
	END IF;

	IF(data <= dataz AND data <= datado) THEN
		RETURN TRUE;
	END IF;

	RETURN FALSE;
END;
$_$;
