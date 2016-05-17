CREATE FUNCTION doskojplatnosciex(integer, integer, integer, numeric, numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idplat ALIAS FOR $1;
 _delta ALIAS FOR $2;
 _flaga ALIAS FOR $3;
 _pozostalowal ALIAS FOR $4;
 _pozostalopln ALIAS FOR $5;
BEGIN

 IF ((_pozostalowal IS NOT NULL) AND (_pozostalopln IS NOT NULL)) THEN 
  IF ((_pozostalowal<>0) OR (_pozostalopln<>0)) THEN
   PERFORM doSkojPlatnosci(_idplat,_delta,0,3);
  END IF;
   PERFORM doSkojPlatnosci(_idplat,_delta,0,4);
 END IF;

 --Normalna
 IF (((_flaga>>11)&3)=0) THEN
  RETURN doSkojPlatnosci(_idplat,_delta,0,0);
 END IF;

 --Nie uzywane wymiary KH
 IF (((_flaga>>11)&3)=1) THEN
  RETURN doSkojPlatnosci(_idplat,_delta,0,1);
 END IF;

 --Nowe wymiary KH
 IF (((_flaga>>11)&3)=2) THEN
  RETURN doSkojPlatnosci(_idplat,_delta,0,2);
 END IF;

 RETURN FALSE;
END;
$_$;
