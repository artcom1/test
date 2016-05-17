CREATE FUNCTION seria2_jp(text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
 seria ALIAS FOR $1;
BEGIN
 IF (seria='   P') THEN
   return '   T';
 ELSE
   return seria;
 END IF;
 return 'Nie znana';
END;
$_$;
