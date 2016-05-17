CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _data ALIAS FOR $1;
 retWeek INT;
 dayOfYear INT;
BEGIN

 retWeek=date_part('week',_data);
 IF (retWeek>50) THEN
  dayOfYear=date_part('doy',_data);
  IF (dayOfYear<30) THEN
   RETURN date_part('year',_data-'1 month'::interval)||'-'||retWeek;
  END IF;
 END IF;
 
 RETURN date_part('year',_data)||'-'||mylpad(retWeek::text,2,'0');
END; $_$;
