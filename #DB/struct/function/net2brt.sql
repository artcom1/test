CREATE FUNCTION net2brt(_value numeric, _stawka numeric) RETURNS numeric
    LANGUAGE sql IMMUTABLE
    AS $_$
SELECT $1+$1*$2/100;
$_$;
