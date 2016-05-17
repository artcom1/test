CREATE FUNCTION cenyzeroflaga(integer, integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _flaga ALIAS FOR $1;
 _flaga_ceny0 ALIAS FOR $2;
BEGIN

 IF (_flaga_ceny0>0) THEN
  RETURN (_flaga|(1<<31));
 ELSE
  RETURN (_flaga&(~(1<<31)));
 END IF;
END;
$_$;
