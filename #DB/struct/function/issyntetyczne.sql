CREATE FUNCTION issyntetyczne(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 IF ($1&1) THEN
  RETURN FALSE;
 ELSE
  RETURN TRUE;
 END IF;
END;
$_$;
