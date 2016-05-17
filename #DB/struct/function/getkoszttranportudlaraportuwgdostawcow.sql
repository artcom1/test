CREATE FUNCTION getkoszttranportudlaraportuwgdostawcow(numeric, numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 kosztt ALIAS FOR $1;
 ilosc ALIAS FOR $2;
 wynik NUMERIC:=0;
BEGIN
 IF (ilosc>0) THEN
  wynik=round(kosztt/ilosc,2);
 END IF;
 return wynik;
END;
$_$;
