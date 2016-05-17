CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 r vendo.notifies;
 t TIMESTAMP;
BEGIN
  IF (vendo.hasNotifyTable()=false) THEN
   RETURN;
  END IF;
  ---------------------------------------------------------------------------------------------------
  t=clock_timestamp();  
  --Zamien notify od rekordow zaleznych na UPDATE
  UPDATE tm_notifies SET nn_cmd=0 WHERE nn_datatype<0;
  --Iteruj
  FOR r IN SELECT nn_cmd,nn_datatype::int2,nn_id AS t 
           FROM tm_notifies 
		   WHERE nn_datatype=COALESCE($1,nn_datatype) AND nn_timestamp<=t 
		   GROUP BY nn_cmd,nn_datatype,nn_id 
		   ORDER BY min(nn_timestamp),max(nn_cmd)
  LOOP
    DELETE FROM tm_notifies WHERE nn_datatype=COALESCE($1,nn_datatype) AND nn_timestamp<=t;
    RETURN NEXT r;
  END LOOP;
END;
$_$;
