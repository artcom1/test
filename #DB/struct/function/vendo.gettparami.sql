CREATE FUNCTION gettparami(text, integer DEFAULT NULL::integer) RETURNS integer
    LANGUAGE sql
    AS $_$
 SELECT COALESCE(vendo.getTParam($1)::int,$2)
$_$;
