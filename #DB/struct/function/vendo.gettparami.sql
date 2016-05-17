CREATE OR REPLACE FUNCTION 
    LANGUAGE sql
    AS $_$
 SELECT COALESCE(vendo.getTParam($1)::int,$2)
$_$;
