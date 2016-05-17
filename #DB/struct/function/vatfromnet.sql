CREATE FUNCTION vatfromnet(numeric, numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN $1*$2/100;
END;
$_$;
