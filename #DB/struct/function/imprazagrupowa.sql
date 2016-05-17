CREATE FUNCTION imprazagrupowa(numeric) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
 ilosc ALIAS FOR $1;
BEGIN
 IF (ilosc>=9) THEN
   return 'Grupowa';
 ELSE
   return 'Indywidualna';
 END IF;
 return 'Nie znana';
END;
$_$;
