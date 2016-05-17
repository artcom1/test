CREATE FUNCTION pliskasa(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
RETURN (($1&3)=1);
END;
$_$;
