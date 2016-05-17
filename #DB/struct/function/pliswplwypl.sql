CREATE FUNCTION pliswplwypl(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN (($1&64)=0) AND (($1&384)=0) AND (($1&6144)<>4096);
END;
$_$;