CREATE FUNCTION teisblockedruch(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 IF (($1&8)<>0) THEN
  RETURN TRUE;
 ELSE
  RETURN FALSE;
 END IF;
END;
$_$;