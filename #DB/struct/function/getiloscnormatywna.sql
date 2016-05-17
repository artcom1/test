CREATE FUNCTION getiloscnormatywna(numeric, numeric, numeric, numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _rbh      ALIAS FOR $1; ---czas pracy maszyny
 _tpj       ALIAS FOR $2;
 _tpz       ALIAS FOR $3;
 _wydajnosc ALIAS FOR $4;
 wynik      NUMERIC:=0;
BEGIN

 wynik=_rbh-_tpz;

 IF (wynik<=0) THEN
  return 0;
 END IF;

 if (_tpj>0) THEN
  wynik=wynik*_wydajnosc/_tpj;
 ELSE
  wynik=0;
 END IF;

 RETURN wynik;
END;
$_$;
