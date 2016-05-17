CREATE FUNCTION vatfrombrt(numeric, numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN $1-(100*$1/(100+$2));
END;
$_$;
