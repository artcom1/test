CREATE FUNCTION nazwiskoimie(text, text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN $1||' '||$2;
END;
$_$;
