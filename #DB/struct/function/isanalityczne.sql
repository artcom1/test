CREATE FUNCTION isanalityczne(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 IF ($1&2) THEN
  RETURN FALSE;
 ELSE
  RETURN TRUE;
 END IF;
END;
$_$;
