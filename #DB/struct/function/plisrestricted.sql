CREATE FUNCTION plisrestricted(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$ 
BEGIN
 RETURN (($1&131072)<>0);
END;
$_$;
