CREATE FUNCTION firstnotnull(numeric, numeric) RETURNS numeric
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 IF NOT ($1=NULL) THEN RETURN $1; END IF;
 RETURN $2;
END;$_$;
