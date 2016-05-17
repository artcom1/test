CREATE FUNCTION getdatadokubelkasymulacyjnego(integer, integer, integer) RETURNS timestamp without time zone
    LANGUAGE plpgsql
    AS $_$
DECLARE
 wynik TIMESTAMP;
BEGIN
	wynik = (SELECT datado FROM getDatyRozmiaruKubelkaSymulacyjnego($1, $2, $3, true));
	RETURN wynik;
END;
$_$;
