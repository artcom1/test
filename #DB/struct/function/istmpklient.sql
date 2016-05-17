CREATE FUNCTION istmpklient(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN ($1&(1<<23))<>0;
END;
$_$;
