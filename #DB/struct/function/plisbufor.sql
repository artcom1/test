CREATE FUNCTION plisbufor(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN (($1&6144)=2048);
END;
$_$;
