CREATE FUNCTION klismobile(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN ($1&(1<<8))<>0;
END;
$_$;
