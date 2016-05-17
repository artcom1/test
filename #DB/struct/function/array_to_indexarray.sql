CREATE FUNCTION array_to_indexarray(numeric[]) RETURNS integer[]
    LANGUAGE plpgsql
    AS $_$
DECLARE
  ret INT[];
  arr ALIAS FOR $1;
BEGIN
  IF (arr IS NULL) THEN
   RETURN NULL;
  END IF;
  
  FOR i IN array_lower( arr,1 )..array_upper( arr,1 ) LOOP
    ret[i]=i;
  END LOOP;

  RETURN ret;
END
$_$;
