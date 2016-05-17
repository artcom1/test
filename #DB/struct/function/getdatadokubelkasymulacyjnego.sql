CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 wynik TIMESTAMP;
BEGIN
	wynik = (SELECT datado FROM getDatyRozmiaruKubelkaSymulacyjnego($1, $2, $3, true));
	RETURN wynik;
END;
$_$;
