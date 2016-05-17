CREATE FUNCTION ispodzialbyusluga(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _tel_flaga       ALIAS FOR $1;
 _tel_newflaga    ALIAS FOR $2;

BEGIN
 IF ((_tel_flaga&4)=0 OR (_tel_newflaga&256)=256) THEN
  RETURN 0;
 END IF;
 
 RETURN 4;
END;
$_$;
