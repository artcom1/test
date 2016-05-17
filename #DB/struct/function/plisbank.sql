CREATE FUNCTION plisbank(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN (($1&3)=0);
END;
$_$;
