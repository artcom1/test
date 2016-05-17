CREATE FUNCTION teisophandel(integer) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
SELECT (($1&2)<>0);
$_$;
