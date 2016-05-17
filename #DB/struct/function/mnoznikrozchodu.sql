CREATE FUNCTION mnoznikrozchodu(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 rc_flaga ALIAS FOR $1;
 wynik INT:=0;
BEGIN
 IF (isPZET(rc_flaga) OR isKPZ(rc_flaga)) THEN
  wynik=1;
 END IF;
 
 RETURN wynik;
END;
$_$;
