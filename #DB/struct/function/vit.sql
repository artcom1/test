CREATE FUNCTION vit(boolean, numeric) RETURNS numeric
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 IF ($1=TRUE) THEN
  RETURN $2;
 END IF;

 RETURN 0;
END;$_$;
