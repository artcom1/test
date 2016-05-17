CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtrans ALIAS FOR $1;
 _delta ALIAS FOR $2;
 _flaga ALIAS FOR $3;
 _pozostalowal ALIAS FOR $4;
 _pozostalopln ALIAS FOR $5;
BEGIN

 IF ((_pozostalowal IS NOT NULL) AND (_pozostalopln IS NOT NULL)) THEN 
  IF ((_pozostalowal<>0) OR (_pozostalopln<>0)) THEN
   PERFORM doSkojTrans(_idtrans,_delta,0,3);
  END IF;
   PERFORM doSkojTrans(_idtrans,_delta,0,4);
 END IF;

 --Normalna
 IF (((_flaga>>11)&3)=0) THEN
  RETURN doSkojTrans(_idtrans,_delta,0,0);
 END IF;

 --Nie uzywane wymiary KH
 IF (((_flaga>>11)&3)=1) THEN
  RETURN doSkojTrans(_idtrans,_delta,0,1);
 END IF;

 --Nowe wymiary KH
 IF (((_flaga>>11)&3)=2) THEN
  RETURN doSkojTrans(_idtrans,_delta,0,2);
 END IF;

 RETURN FALSE;
END;
$_$;
