CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 _flaga ALIAS FOR $1;
BEGIN
 IF (_flaga=0) THEN 
  return 'Grupa A';
 END IF;

 IF (_flaga=32768) THEN 
  return 'Grupa B';
 END IF;

 IF (_flaga=65536) THEN 
  return 'Grupa C';
 END IF;

 IF (_flaga=98304) THEN 
  return 'Grupa D';
 END IF;

 RETURN '';
END;$_$;
