CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
BEGIN

 IF ($1 IS NULL) THEN RETURN $2; END IF;
 IF ($2 IS NULL) THEN RETURN $1; END IF;

 IF ($1>$2) THEN
  RETURN $1;
 ELSE
  RETURN $2;
 END IF;

END
$_$;
