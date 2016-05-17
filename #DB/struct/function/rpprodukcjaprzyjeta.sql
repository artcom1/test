CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 wartosc ALIAS FOR $1;
 flaga ALIAS FOR $2;
 sprzedaz ALIAS FOR $3;
BEGIN
 IF (sprzedaz>0) AND ((flaga&8)=0) THEN
  RETURN wartosc;
 ELSE
  RETURN 0;
 END IF;
END;
$_$;
