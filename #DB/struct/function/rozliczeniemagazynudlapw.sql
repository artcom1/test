CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 wartosc ALIAS FOR $1;
 rodzaj ALIAS FOR $2;
BEGIN
 if (rodzaj=5 OR rodzaj=15) THEN
  RETURN wartosc;
 END IF;
 
 RETURN 0;
END;
$_$;
