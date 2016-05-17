CREATE FUNCTION sprzedane(numeric) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
 fv ALIAS FOR $1;
BEGIN
 IF (fv>0) THEN
   return 'TAK';
 ELSE
   return 'NIE';
 END IF;
 return 'Nie znana';
END;
$_$;
