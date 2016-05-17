CREATE FUNCTION mnoznikkorekt(integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 IF (($1&8)<>0) THEN
  RETURN 0;
 ELSE
  RETURN 1;
 END IF;
END;
$_$;
