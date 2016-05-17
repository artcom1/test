CREATE FUNCTION uzupelnijmiesiac(date) RETURNS text
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


--
--

CREATE FUNCTION uzupelnijmiesiac(double precision) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
 miesiac ALIAS FOR $1;
 
BEGIN
 return uzupelnijmiesiac(miesiac::text);

END;
$_$;


--
--

CREATE FUNCTION uzupelnijmiesiac(text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
 miesiac ALIAS FOR $1;
 
BEGIN
 IF ((miesiac::int)<10) THEN
   return '0'||miesiac;
 ELSE
   return miesiac;
 END IF;

END;
$_$;
