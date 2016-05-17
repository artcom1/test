CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 typ    ALIAS FOR $1;
 rodzaj ALIAS FOR $2;
 val    ALIAS FOR $3;
 defval ALIAS FOR $4;
 ret    TEXT;
BEGIN
 ret=(SELECT replace(rn_value, val || '_','') FROM ts_rozne AS t WHERE ((((rn_typ=typ) AND (rn_id=rodzaj) AND (substr(rn_value,0,strpos(rn_value,'_'))= val)))));

 IF (ret IS NULL OR ret='') THEN
  ret=defval;
 END IF; 
  
 RETURN ret;
 END;
$_$;
