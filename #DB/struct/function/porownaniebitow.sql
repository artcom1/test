CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 wynik INT;
BEGIN
 wynik=0;
 IF (($1&$2)=$3) THEN 
   wynik=1;
 END IF;
 RETURN wynik;
END;$_$;
