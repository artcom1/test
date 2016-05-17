CREATE FUNCTION policzwspolczynnik(numeric, numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 licznik ALIAS FOR $1;
 mianownik ALIAS FOR $2;
 wynik NUMERIC;
BEGIN
 IF (mianownik>0) THEN
   wynik=round(licznik/mianownik,4);
 ELSE
  IF (mianownik=0 AND licznik=0) THEN
   wynik=0;
  ELSE
   wynik=1;
  END IF;
 END IF;
 return wynik;
END;
$_$;
