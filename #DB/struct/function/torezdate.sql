CREATE FUNCTION torezdate(date, integer) RETURNS date
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN

 IF (RCisRezerwacjaR($2)) THEN
  RETURN $1;
 ELSE
  RETURN NULL;
 END IF;
END;
$_$;
