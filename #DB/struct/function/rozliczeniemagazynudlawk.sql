CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 wartosc ALIAS FOR $1;
 rodzaj ALIAS FOR $2;
BEGIN
 if (rodzaj=108 OR rodzaj=208 ) THEN
  RETURN wartosc;
 END IF;
 
 RETURN 0;
END;
$_$;
