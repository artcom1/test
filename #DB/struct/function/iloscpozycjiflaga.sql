CREATE FUNCTION iloscpozycjiflaga(integer, numeric) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _flaga ALIAS FOR $1;
 _pozycji ALIAS FOR $2;
BEGIN

 IF (nullZero(_pozycji)=0) THEN
  RETURN (_flaga&(~(1<<23)));
 ELSE
  RETURN (_flaga|(1<<23));
 END IF;
END;
$_$;
