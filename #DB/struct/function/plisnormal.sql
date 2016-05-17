CREATE FUNCTION plisnormal(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN (($1&6144)=0);
END;
$_$;
