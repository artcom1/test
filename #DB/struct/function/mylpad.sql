CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 IF (length($1)>=$2) THEN
  RETURN $1;
 ELSE
  RETURN lpad($1,$2,$3);
 END IF;
END;
$_$;
