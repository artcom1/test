CREATE FUNCTION settparami(text, integer) RETURNS integer
    LANGUAGE sql
    AS $_$
 SELECT vendo.setTParam($1,$2::text)::int;
$_$;
