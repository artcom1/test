CREATE FUNCTION kierunekrozrachunku(integer, numeric) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 flg INT:=1;
BEGIN
 IF ($1=0) THEN
  RETURN 0;
 END IF;
 RETURN sign($2);
END;$_$;
