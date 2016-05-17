CREATE FUNCTION teisprzychod(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 IF (($1&4)<>0) THEN
  RETURN FALSE;
 ELSE
  RETURN TRUE;
 END IF;
END;
$_$;
