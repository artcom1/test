CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _forma ALIAS FOR $1;
 _toHM ALIAS FOR $2;
BEGIN
 IF (_toHM) THEN
  IF (_forma>=0) THEN
   RETURN -(_forma+1);
  END IF;
 ELSE
  IF (_forma<0) THEN
   RETURN -(_forma+1);
  END IF;
 END IF;
 RETURN _forma;
END;
$_$;
