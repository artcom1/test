CREATE FUNCTION plismcash(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN (($1&64)=64);
END;
$_$;
