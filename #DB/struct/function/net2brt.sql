CREATE OR REPLACE FUNCTION 
    LANGUAGE sql IMMUTABLE
    AS $_$
SELECT $1+$1*$2/100;
$_$;
