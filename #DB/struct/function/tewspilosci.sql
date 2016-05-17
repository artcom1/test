CREATE FUNCTION tewspilosci(integer) RETURNS numeric
    LANGUAGE sql IMMUTABLE
    AS $_$
SELECT (CASE WHEN ($1&4)<>0 THEN 1::numeric ELSE -1::numeric END)
$_$;
