CREATE FUNCTION markneedvalid(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
BEGIN
 IF (vat.disableRecalcing($1,0)=0) THEN
  RETURN TRUE;
 END IF;

 PERFORM vendo.setTParamI('DRCSVN_'||$1,1);
 RETURN FALSE;
END;
$_$;
