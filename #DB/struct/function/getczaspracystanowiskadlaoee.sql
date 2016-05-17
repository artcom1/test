CREATE FUNCTION getczaspracystanowiskadlaoee(integer, timestamp with time zone, timestamp with time zone, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _knw_idelemu ALIAS FOR $1;
 _datastart ALIAS FOR $2;
 _datastop  ALIAS FOR $3;
 _flaga     ALIAS FOR $4;
 wynik      NUMERIC:=0;
 roznica INTERVAL;
BEGIN
 IF (_flaga&3=3) THEN 
  return getCzasPracyStanowiska(_datastart,_datastop,_flaga);
 ELSE
  wynik=(SELECT max(kwd_rbh) FROM tr_kkwnodwykdet WHERE knw_idelemu=_knw_idelemu);
 END IF;
 RETURN wynik;
END;
$_$;
