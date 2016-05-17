CREATE FUNCTION maxdate(timestamp with time zone, timestamp with time zone) RETURNS timestamp with time zone
    LANGUAGE plpgsql
    AS $_$
DECLARE
 t1 ALIAS FOR $1;
 t2 ALIAS FOR $2;
BEGIN
 
 IF (t1>t2) THEN
  RETURN t1;
 ELSE
  RETURN t2;
 END IF;

END;
$_$;
