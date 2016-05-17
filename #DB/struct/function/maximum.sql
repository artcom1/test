CREATE FUNCTION maximum(numeric, numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
BEGIN
 IF ($1>$2) THEN 
  RETURN $1;
 ELSE
  RETURN $2;
 END IF;

 RETURN 0;
END;
$_$;
