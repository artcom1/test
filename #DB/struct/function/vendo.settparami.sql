CREATE OR REPLACE FUNCTION 
    LANGUAGE sql
    AS $_$
 SELECT vendo.setTParam($1,$2::text)::int;
$_$;
