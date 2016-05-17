CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _flaga ALIAS FOR $1;
 _typ   ALIAS FOR $2;
BEGIN
 RETURN ((_flaga&(7+16))=(_typ&(7+16)));
END;
$_$;
