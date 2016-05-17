CREATE FUNCTION tostringnull(integer) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 IF ($1 IS NULL) THEN
  RETURN 'NULL';
 END IF;

 RETURN $1::TEXT;
END; $_$;
