CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idkonta ALIAS FOR $1;
 _idref ALIAS FOR $2;
 r RECORD;
BEGIN

 IF (_idref IS NULL) THEN
  RETURN 0;
 END IF;

 SELECT * INTO r FROM kh_konta WHERE kt_ref=_idref AND kt_idkonta<>_idkonta LIMIT 1 OFFSET 0;
 IF FOUND THEN
  RETURN 0;
 END IF;

 RETURN 2;
END;
$_$;
