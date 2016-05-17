CREATE FUNCTION rilike(text, text) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$select $2 ilike $1$_$;
