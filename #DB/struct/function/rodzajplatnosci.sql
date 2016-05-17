CREATE FUNCTION rodzajplatnosci(integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
 rodzaj ALIAS FOR $1;
 wynik TEXT;
BEGIN
 wynik=(SELECT fp_nazwa FROM ts_formaplat WHERE pl_formaplat=rodzaj);

 return wynik;
END;
$_$;
