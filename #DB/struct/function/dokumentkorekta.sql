CREATE FUNCTION dokumentkorekta(integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
 rodzaj ALIAS FOR $1;

BEGIN
 IF (rodzaj<10) THEN
  RETURN 'D';
 ELSE
  RETURN 'K';
 END IF;
END;
$_$;
