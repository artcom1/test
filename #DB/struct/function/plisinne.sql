CREATE FUNCTION plisinne(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
RETURN (($1&3)=2);
END;
$_$;
