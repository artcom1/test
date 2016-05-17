CREATE FUNCTION pliskompensata(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN ($1&3)=3;
END
$_$;
