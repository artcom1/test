CREATE FUNCTION teisblockedruchy(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
BEGIN
 IF (($1&8)=8) THEN
  RETURN TRUE;
 ELSE
  RETURN FALSE;
 END IF;
END;
$_$;