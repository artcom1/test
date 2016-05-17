CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 wartosc ALIAS FOR $1;
 rodzaj ALIAS FOR $2;
BEGIN
 if (rodzaj=0 OR rodzaj=10 OR rodzaj=100 OR rodzaj=200) THEN
  RETURN wartosc;
 END IF;
 
 RETURN 0;
END;
$_$;
