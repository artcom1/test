CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 wynik TIMESTAMP;
BEGIN
	wynik = (SELECT dataod FROM getDatyRozmiaruKubelkaSymulacyjnego($1, $2, $3, false));
	RETURN wynik;
END;
$_$;
