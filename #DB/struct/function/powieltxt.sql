CREATE FUNCTION powieltxt(text, integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _txt ALIAS FOR $1;
 _ile ALIAS FOR $2;
 ret TEXT:=_txt;
 ile INT:=_ile;
BEGIN
 IF (ile <=0) THEN
  RETURN NULL;
 END IF;

 ret=_txt;

 LOOP
  EXIT WHEN ile<=1;
  
  ret = ret ||'??'|| _txt;
  ile = ile - 1;
 END LOOP;
 
 RETURN ret;
END;
$_$;
