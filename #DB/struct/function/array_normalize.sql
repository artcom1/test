CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
  arr_wzorzec ALIAS FOR $1;
  arr_new ALIAS FOR $2;
  
  ret NUMERIC[];
BEGIN
 IF (arr_wzorzec IS NULL) THEN
  RETURN NULL;
 END IF;
  
  FOR i IN array_lower( arr_wzorzec,1 )..array_upper( arr_wzorzec,1 ) LOOP
   IF (arr_wzorzec[i] IS NULL) THEN
    ret[i]=NULL;
   ELSE
    ret[i]=arr_new[i];
   END IF;
  END LOOP;

  RETURN ret;  
END
$_$;
