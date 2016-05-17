CREATE FUNCTION getprzelokresusalda(integer, integer, integer, boolean) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 ile_dni ALIAS FOR $1;
 okres ALIAS FOR $2;
 dlugoscokresu ALIAS FOR $3;
 nieskonczonosc ALIAS FOR $4;
BEGIN 
 IF (okres=0 ) THEN 
  IF (ile_dni<=0) THEN 
   return 1;
  ELSE 
   return 0;
  END IF;
 END IF;
 IF (nieskonczonosc) THEN
  IF (ile_dni>=(((okres-1)*dlugoscokresu)+1)) THEN
   return 1;
  END IF;
 END IF;
 IF (ile_dni>=(((okres-1)*dlugoscokresu)+1) AND ile_dni<=(dlugoscokresu*okres)) THEN
   return 1;
 END IF;
 return 0;
END;
$_$;
