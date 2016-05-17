CREATE FUNCTION isdigit(text) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
select $1 ~ '^(-)?[0-9]+$' as result
$_$;
