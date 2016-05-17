CREATE FUNCTION mnoznikprzychodu(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 rc_flaga ALIAS FOR $1;
 wynik INT:=0;
BEGIN
 if (isFV(rc_flaga) OR isKFV(rc_flaga)) THEN
  wynik=1;
 END IF;
 
 RETURN wynik;
END;
$_$;
