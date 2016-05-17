CREATE FUNCTION pliscanceled(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN (($1&6144)=4096);
END;
$_$;
