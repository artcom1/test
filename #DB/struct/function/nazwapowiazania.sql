CREATE FUNCTION nazwapowiazania(integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 _flaga ALIAS FOR $1;
BEGIN
 IF (_flaga&32=32) THEN 
  return 'Kalkulacje';
 END IF;

 IF (_flaga&(64+65536)=64) THEN 
  return 'Produkcja KKW';
 END IF;

 IF (_flaga&128=128) THEN 
  return 'Receptury';
 END IF;

 IF (_flaga&(64+65536)=(64+65536)) THEN 
  return 'Produkcja MRP';
 END IF;

 RETURN 'Bez powi??zania';
END;$_$;
