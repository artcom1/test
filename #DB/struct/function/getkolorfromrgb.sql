CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _R ALIAS FOR $1;
 _G ALIAS FOR $2;
 _B ALIAS FOR $3;
 ret INTEGER:=0;
BEGIN 
 
 _R=(_R<<16);
 _G=(_G<<8);
 _B=(_B<<0);
 
 ret=_R+_G+_B;
    
 RETURN ret;
END
$_$;
