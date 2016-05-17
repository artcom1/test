CREATE FUNCTION pliswplata(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN (($1&1024)=1024);
END;
$_$;
