CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
	dataod ALIAS FOR $1; --przedzial czasu zadany filtrami
	datado ALIAS FOR $2; --przedzial czasu zadany filtrami

	datar ALIAS FOR $3; --ramy czasowe cyklicznosci zdarzenia
	dataz ALIAS FOR $4; --ramy czasowe cyklicznosci zdarzenia

	data DATE;
	kwac INT;
BEGIN
	IF (dataz < dataod OR datar > datado) THEN
		RETURN FALSE;
	END IF;

	kwac := getRoznicaLat(dataod, datar) * 4;
	data := datar + kwac * '3 months'::interval;

	IF (date(data) < dataod) THEN
		WHILE (date(data) < dataod) LOOP
			kwac := kwac + 1;
			data := datar + kwac * '+3 months'::interval;
		END LOOP;
	ELSE
		WHILE ((date(data) - '3 months'::interval) > dataod) LOOP
			kwac := kwac - 1;
			data := datar + kwac * '+3 months'::interval;
		END LOOP;		
	END IF;

	IF(data <= dataz AND data <= datado) THEN
		RETURN TRUE;
	END IF;

	RETURN FALSE;
END;
$_$;
