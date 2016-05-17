CREATE FUNCTION rcodwrocenie(integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 t1 ALIAS FOR $1;
BEGIN
  IF (t1&(32+4096))=32 THEN
  RETURN -1;
 ELSE
  RETURN 1;
 END IF;
END;
$_$;
