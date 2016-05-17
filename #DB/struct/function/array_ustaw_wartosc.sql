CREATE FUNCTION array_ustaw_wartosc(integer[], integer) RETURNS integer[]
    LANGUAGE plpgsql
    AS $_$
DECLARE
  wynik int[];
  ar   ALIAS FOR $1;
  wart   ALIAS FOR $2;
BEGIN
  IF (ar IS NULL) THEN
   RETURN NULL;
  END IF;
  FOR i IN array_lower( ar,1 )..array_upper( ar,1 ) LOOP
    wynik[i]=wart;
  END LOOP;

  RETURN wynik;
END
$_$;


--
--

CREATE FUNCTION array_ustaw_wartosc(numeric[], numeric) RETURNS numeric[]
    LANGUAGE plpgsql
    AS $_$
DECLARE
  wynik NUMERIC[];
  ar   ALIAS FOR $1;
  wart   ALIAS FOR $2;
BEGIN
  IF (ar IS NULL) THEN
   RETURN NULL;
  END IF;
  FOR i IN array_lower( ar,1 )..array_upper( ar,1 ) LOOP
    wynik[i]=wart;
  END LOOP;

  RETURN wynik;
END
$_$;
