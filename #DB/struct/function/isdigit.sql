CREATE OR REPLACE FUNCTION 
    LANGUAGE sql IMMUTABLE
    AS $_$
select $1 ~ '^(-)?[0-9]+$' as result
$_$;
