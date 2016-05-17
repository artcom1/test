CREATE FUNCTION teisusluga(integer) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
SELECT ($1&4)<>0;
$_$;
