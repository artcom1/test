CREATE FUNCTION array_round(numeric[], integer) RETURNS numeric[]
    LANGUAGE plpgsql
    AS $_$
DECLARE
  wynik NUMERIC[];
  ar   ALIAS FOR $1;
  ile   ALIAS FOR $2;
BEGIN
  IF (ar IS NULL) THEN
   RETURN NULL;
  END IF;
  FOR i IN array_lower( ar,1 )..array_upper( ar,1 ) LOOP
    wynik[i]=round(ar[i],ile);
  END LOOP;

  RETURN wynik;
END
$_$;
