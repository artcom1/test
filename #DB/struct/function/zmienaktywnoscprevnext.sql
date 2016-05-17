CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _kwe_idelemu ALIAS FOR $1;
 _aktywacja   ALIAS FOR $2;
 -- 0 - dezaktywacja
 -- 1 - aktywacja 
BEGIN
 IF (COALESCE(_kwe_idelemu,0)<=0) THEN
  RETURN -1;
 END IF;
 
 IF (_aktywacja=TRUE) THEN
  RETURN aktywujPrevNext(_kwe_idelemu);
 ELSE
  RETURN dezaktywujPrevNext(_kwe_idelemu);
 END IF;
 
 RETURN -1;
END;
$_$;
