CREATE FUNCTION teisopmagazyn(integer) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
 SELECT (($1&1)<>0);
$_$;
