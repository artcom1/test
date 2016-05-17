CREATE FUNCTION isapzet(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN (($1&4)=4);
END;
$_$;
