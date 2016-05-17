CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
 
 
 IF (idelem IS NULL) THEN
  RETURN FALSE;
 END IF;

 IF (vendo.getTParamI('TEDELETED_'||idelem::text,0)!=1) AND (vendo.getTParamI('TEXDELETED_'||COALESCE(texidelem,-1)::text,0)!=1) THEN
  RETURN FALSE;
 END IF;
 
 
 IF ((isrozchod=TRUE) AND (vendo.getConfigValue('ALLOWDELCOMMITED_-1') IS DISTINCT FROM '1')) THEN
  RETURN FALSE;
 END IF;
 
 IF ((isrozchod=FALSE) AND (vendo.getConfigValue('ALLOWDELCOMMITED_1') IS DISTINCT FROM '1')) THEN
  RETURN FALSE;
 END IF;
 
 RETURN TRUE;
END
$$;
