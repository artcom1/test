CREATE FUNCTION zerojeden(numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
BEGIN
 IF ($1=NULL) THEN
  RETURN 0;
 ELSE
  RETURN 1;
 END IF;
END;
$_$;