CREATE FUNCTION getnormatywprac(numeric, numeric, numeric, numeric, numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _ilosc     ALIAS FOR $1;
 _tpj       ALIAS FOR $2;
 _tpz       ALIAS FOR $3;
 _wydajnosc ALIAS FOR $4;
 _iloscosob ALIAS FOR $5;
 wynik      NUMERIC:=0;
BEGIN
 IF (_wydajnosc!=0) THEN
  wynik=(_ilosc*_tpj)/_wydajnosc+_tpz;
  wynik=wynik*_iloscosob;
  wynik=Round(wynik/60,4);  ---normawyt do h
 END IF; 
 RETURN wynik;
END;
$_$;
