CREATE FUNCTION getwydajnosc(numeric, numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _normatyw ALIAS FOR $1;
 _czas     ALIAS FOR $2;
 
 wynik     NUMERIC:=0;
BEGIN
 IF (_normatyw=0) THEN
  RETURN 100;
 END IF;
 
 IF (_czas=0) THEN
  RETURN 0;
 END IF;
 
 wynik=(_normatyw/_czas)*100;
 RETURN wynik;
END;
$_$;
