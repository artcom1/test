CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _wartosc ALIAS FOR $1;
 _por ALIAS FOR $2;
 _wzorzec ALIAS FOR $3;
BEGIN

 IF (_por=_wzorzec) THEN
  RETURN _wartosc;

 END IF;

 RETURN 0;

END;
$_$;
