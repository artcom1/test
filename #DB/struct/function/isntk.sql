CREATE FUNCTION isntk(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
BEGIN
 IF (($1&(1<<22))=(1<<22)) THEN
  RETURN TRUE;
 END IF;

 RETURN FALSE;
END;$_$;
