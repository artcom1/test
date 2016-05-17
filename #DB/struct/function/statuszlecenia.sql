CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 rodzaj ALIAS FOR $1;
 
BEGIN
 IF (rodzaj=0) THEN
   return 'Przedplanowane';
 END IF;
 IF (rodzaj=1) THEN
   return 'Realizowane';
 END IF;
 IF (rodzaj=2) THEN
   return 'Wykonane';
 END IF;
 IF (rodzaj=3) THEN
   return 'Anulowane';
 END IF;
 return 'nieznane';
END;
$_$;
