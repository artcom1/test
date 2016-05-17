CREATE OR REPLACE FUNCTION 
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

CREATE OR REPLACE FUNCTION 
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

CREATE OR REPLACE FUNCTION 
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
