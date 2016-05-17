CREATE FUNCTION getczaspracystanowiska(timestamp with time zone, timestamp with time zone, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _datastart ALIAS FOR $1;
 _datastop  ALIAS FOR $2;
 _flaga     ALIAS FOR $3;
 wynik      NUMERIC:=0;
 roznica INTERVAL;
BEGIN
 IF (_flaga&3=3) THEN 
  roznica=_datastop-_datastart;
  wynik=date_part('days',roznica)*24+date_part('hours',roznica)+date_part('minute',roznica)/60;
  wynik=round(wynik,2);
 END IF;
 RETURN wynik;
END;
$_$;
