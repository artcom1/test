CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
  wynik NUMERIC:=0;
  ar   ALIAS FOR $1;
BEGIN
  IF (ar IS NULL) THEN
   RETURN NULL;
  END IF;
  FOR i IN array_lower( ar,1 )..array_upper( ar,1 ) LOOP
    wynik=wynik+NullZero(ar[i]);
  END LOOP;

  RETURN wynik;
END
$_$;
