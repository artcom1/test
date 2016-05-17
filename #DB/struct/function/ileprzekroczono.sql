CREATE FUNCTION ileprzekroczono(numeric, numeric) RETURNS numeric
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 IF ($1=0) THEN
  RETURN $2;
 END IF;
 IF (sign($1)=sign($2)) THEN
  RETURN 0;
 END IF;
 RETURN abs($2);
END;$_$;