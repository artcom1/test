CREATE OR REPLACE FUNCTION 
    LANGUAGE sql IMMUTABLE
    AS $_$
 SELECT (CASE WHEN $1&15>4 THEN 4 ELSE $1&15 END);
$_$;
