CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE 
  zapytanie INT;
  cur REFCURSOR;
BEGIN
   OPEN cur FOR EXECUTE 'SELECT '||$3||' FROM '||$2||' WHERE oid='||$1;
   FETCH cur INTO zapytanie;
   CLOSE cur;
   RETURN zapytanie;
END;
$_$;
