CREATE FUNCTION text2int(text) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 IF ($1='') THEN
  RETURN NULL;
 END IF;
    
 RETURN $1::int;
END;
$_$;
