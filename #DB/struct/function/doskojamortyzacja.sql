CREATE FUNCTION doskojamortyzacja(integer, integer, numeric, numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idam ALIAS FOR $1;
 _ile ALIAS FOR $2;
 _pozostalowal ALIAS FOR $3;
 _pozostalopln ALIAS FOR $4;
 r RECORD;
BEGIN

 IF ((_pozostalowal IS NOT NULL) AND (_pozostalopln IS NOT NULL)) THEN 
  IF ((_pozostalowal<>0) OR (_pozostalopln<>0)) THEN
   PERFORM doSkojAmortyzacjaEx(_idam,_ile,3);
  END IF;
  PERFORM doSkojAmortyzacjaEx(_idam,_ile,4);
 END IF;
 
 RETURN doSkojAmortyzacjaEx(_idam,_ile,0);
END;
$_$;
