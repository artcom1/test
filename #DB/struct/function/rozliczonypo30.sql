CREATE FUNCTION rozliczonypo30(date, date) RETURNS double precision
    LANGUAGE plpgsql
    AS $_$
DECLARE
 data_roz ALIAS FOR $1;
 data_plat ALIAS FOR $2;
 data DATE;
BEGIN
 IF (data_roz = NULL) THEN
  return 0;
 END IF;
 IF ((data_roz-data_plat)>30) THEN 
   return 1;
 ELSE
   return 0;
 END IF ;
 return 0;
END;
$_$;
