CREATE FUNCTION pliszaliczka(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN (($1&512)=512);
END;
$_$;
