CREATE OR REPLACE FUNCTION 
    LANGUAGE sql IMMUTABLE
    AS $_$
SELECT ($1&4)<>0;
$_$;
