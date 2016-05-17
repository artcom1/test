CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 tmp INT;
BEGIN
 tmp=vendo.gettparami('GM.DISABLETOUCH',0);
 
 IF ($1=0) THEN
  RETURN tmp;
 END IF;

 IF ($1>0) THEN
  tmp=tmp+$1;
  PERFORM vendo.settparami('GM.DISABLETOUCH',tmp);
  RETURN tmp;
 END IF;

 tmp=tmp+$1;
 PERFORM vendo.settparami('GM.DISABLETOUCH',tmp);

 IF (tmp=0) THEN
  PERFORM gm.execTouch();
 END IF;

 RETURN tmp;
END;
$_$;
