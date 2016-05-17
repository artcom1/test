CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
	dataod ALIAS FOR $1; --przedzial czasu zadany filtrami
	datado ALIAS FOR $2; --przedzial czasu zadany filtrami

	ck_datarozpoczecia ALIAS FOR $3; --ramy czasowe cyklicznosci zdarzenia
	ck_datazakonczenia ALIAS FOR $4; --ramy czasowe cyklicznosci zdarzenia
	
	ck_okres ALIAS FOR $5; --okres cyklu

	rec RECORD;
	ret BOOLEAN;
BEGIN
	IF (dataod > datado) THEN
		RETURN FALSE;
	END IF;

	IF (ck_okres = '+1 days'::interval) THEN
		ret := sprawdzDziennyCykl(dataod, datado, ck_datarozpoczecia, ck_datazakonczenia);
		RETURN ret;
	END IF;
	
	IF (ck_okres = '+1 week'::interval) THEN
		ret := sprawdzTygodniowyCykl(dataod, datado, ck_datarozpoczecia, ck_datazakonczenia);
		RETURN ret;
	END IF;
	
	IF (ck_okres = '+1 month'::interval) THEN
		ret := sprawdzMiesiecznyCykl(dataod, datado, ck_datarozpoczecia, ck_datazakonczenia);
		RETURN ret;
	END IF;

	IF (ck_okres = '+3 months'::interval) THEN
		ret := sprawdzKwartalnyCykl(dataod, datado, ck_datarozpoczecia, ck_datazakonczenia);
		RETURN ret;
	END IF;

	IF (ck_okres = '+1 year'::interval) THEN
		ret := sprawdzRocznyCykl(dataod, datado, ck_datarozpoczecia, ck_datazakonczenia);
		RETURN ret;
	END IF;

	return FALSE;
END;
$_$;
