CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 data_roz ALIAS FOR $1;
 data_plat ALIAS FOR $2;
 data DATE;
BEGIN
 IF (data_roz = NULL) THEN
  data=now();
 ELSE
  data=data_roz;
 END IF;
 return data-data_plat;
END;
$_$;
