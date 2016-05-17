CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
BEGIN
 IF (vat.disableRecalcing($1,0)=0) THEN
  RETURN TRUE;
 END IF;
 PERFORM vendo.setTParamI('DRCSVH_'||$1,1);
 RETURN FALSE;
END;
$_$;
