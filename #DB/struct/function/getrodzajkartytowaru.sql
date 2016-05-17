CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 _flaga ALIAS FOR $1;
 _usluga ALIAS FOR $2;
BEGIN
 IF (_flaga&(20+262144+524288)=4) THEN 
  return 'KOSZT';
 END IF;

 IF (_flaga&(20+262144+524288)=16) THEN 
  return 'TK';
 END IF;

 IF (_flaga&(20+262144+524288)=262144) THEN 
  return 'KOMPLET';
 END IF;
 
 IF (_flaga&(20+262144+524288)=262144) THEN 
  return 'BILET';
 END IF;

 IF (_usluga) THEN
  return 'USLUGA';
 END IF;

 return 'TOWAR';
END;$_$;
