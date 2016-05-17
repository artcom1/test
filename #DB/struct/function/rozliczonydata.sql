CREATE FUNCTION rozliczonydata(date) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
 data ALIAS FOR $1;
 
BEGIN
 IF (data = NULL) THEN
   return 'NIE';
 ELSE
   return 'TAK';
 END IF;

END;
$_$;
