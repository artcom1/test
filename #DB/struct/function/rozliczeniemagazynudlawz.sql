CREATE FUNCTION rozliczeniemagazynudlawz(numeric, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 wartosc ALIAS FOR $1;
 rodzaj ALIAS FOR $2;
BEGIN
 if (rodzaj=2 OR rodzaj=12 OR rodzaj=7 OR rodzaj=17 OR rodzaj=11) THEN
  RETURN wartosc;
 END IF;
 
 RETURN 0;
END;
$_$;
