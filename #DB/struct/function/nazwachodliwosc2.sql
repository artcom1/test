CREATE FUNCTION nazwachodliwosc2(integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 _flaga ALIAS FOR $1;
BEGIN
 IF (_flaga=0) THEN 
  return 'Grupa X';
 END IF;

 IF (_flaga=64) THEN 
  return 'Grupa Y';
 END IF;

 IF (_flaga=128) THEN 
  return 'Grupa Z';
 END IF;

 RETURN '';
END;$_$;
