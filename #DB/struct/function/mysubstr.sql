CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 tekst ALIAS FOR $1;
 odp ALIAS FOR $2;
 dop ALIAS FOR $3;
 wynik TEXT;
BEGIN
  if (dop<0) THEN
    wynik=tekst;
  ELSE
    wynik=substr(tekst,odp,dop);
  END IF;
  RETURN wynik;
END;
$_$;
