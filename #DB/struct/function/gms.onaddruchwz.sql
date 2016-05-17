CREATE FUNCTION onaddruchwz(idruchunew integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
 simid INT:=vendo.getTParamI('NEWWZTRAP',0);
BEGIN

 IF (simid>0) THEN
  PERFORM gms.copyIDToUse(simid,vendo.getTParamI('NEWWZTRAP_ID',0),idruchunew);
 END IF;

 RETURN TRUE;
END;
$$;
