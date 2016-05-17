CREATE FUNCTION array_nullzero(numeric[]) RETURNS numeric[]
    LANGUAGE plpgsql
    AS $_$
DECLARE
  arr ALIAS FOR $1;  
  ret NUMERIC[];
BEGIN
 IF (arr IS NULL) THEN
  RETURN NULL;
 END IF;
  
  FOR i IN array_lower( arr,1 )..array_upper( arr,1 ) LOOP
   ret[i]=nullzero(arr[i]);
  END LOOP;

  RETURN ret;  
END
$_$;
