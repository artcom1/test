CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
	dataod ALIAS FOR $1; --przedzial czasu zadany filtrami
	datado ALIAS FOR $2; --przedzial czasu zadany filtrami

	datar ALIAS FOR $3; --ramy czasowe cyklicznosci zdarzenia
	dataz ALIAS FOR $4; --ramy czasowe cyklicznosci zdarzenia
BEGIN
	IF (dataz >= dataod AND datar <= datado) THEN
		RETURN TRUE;
	END IF;

	RETURN FALSE;
END;
$_$;
