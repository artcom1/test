CREATE FUNCTION iswykonanieopkkw(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN (($1&1)=1);
END;
$_$;
