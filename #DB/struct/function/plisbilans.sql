CREATE FUNCTION plisbilans(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN (($1&384)<>0);
END;
$_$;
