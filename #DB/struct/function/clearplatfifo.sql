CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
  _idplatnosc ALIAS FOR $1;
BEGIN
 DELETE FROM kh_platfifo WHERE pl_idplatnosc=_idplatnosc;
 RETURN TRUE;    
END;
$_$;
