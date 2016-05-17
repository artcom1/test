CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 IF ($2=0) THEN
  RETURN $1; ---przyjecia
 ELSE
  RETURN -$1; ---wydania
 END IF;
END;
$_$;
