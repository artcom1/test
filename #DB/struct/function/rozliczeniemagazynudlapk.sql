CREATE FUNCTION rozliczeniemagazynudlapk(numeric, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 wartosc ALIAS FOR $1;
 rodzaj ALIAS FOR $2;
BEGIN
 if (rodzaj=109 OR rodzaj=209 ) THEN
  RETURN wartosc;
 END IF;
 
 RETURN 0;
END;
$_$;
