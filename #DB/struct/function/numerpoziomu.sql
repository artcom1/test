CREATE FUNCTION numerpoziomu(text, integer) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 IF ($1='') THEN
  RETURN $2;
 ELSE
  RETURN $1||'.'||$2;
 END IF;
END;
$_$;
