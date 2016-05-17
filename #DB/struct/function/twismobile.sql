CREATE FUNCTION twismobile(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN ($1&(1<<17))<>0;
END;
$_$;
