CREATE FUNCTION getodliczenievat(integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 flaga ALIAS FOR $1;
 wynik TEXT;
BEGIN
 wynik='Nieokreslony';
 IF ((flaga&49152)=(0<<14)) THEN
  wynik='Nie';
 END IF;

 IF ((flaga&49152)=(1<<14)) THEN
  wynik='Warunkowo';
 END IF;

 IF ((flaga&49152)=(2<<14)) THEN
  wynik='Tak';
 END IF;

 return wynik;
END;
$_$;
