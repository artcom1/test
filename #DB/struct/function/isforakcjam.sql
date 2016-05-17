CREATE FUNCTION isforakcjam(integer, integer, integer, integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
  _idakcji ALIAS FOR $1;
  _skojlog ALIAS FOR $2;
  _flaga   ALIAS FOR $3;
  _sprzedaz ALIAS FOR $4;
BEGIN
 IF (_flaga&1024=1024) OR (_sprzedaz>0) THEN
  RETURN FALSE;
 END IF;

 IF (_idakcji IS NULL) THEN
  RETURN FALSE;
 END IF;

 IF (_skojlog IS NOT NULL) THEN
  RETURN FALSE;
 END IF;

 RETURN TRUE;
END;
$_$;
