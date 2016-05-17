CREATE FUNCTION hasanymark(simid integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 tmp  INT;
BEGIN
 tmp=vendo.gettparam('GMS_HASANYMARK'||$1::text);
 IF (tmp IS NOT NULL) THEN
  RETURN (tmp>0);
 END IF;

 tmp=COALESCE((SELECT count(*) FROM gms.tm_marked WHERE sc_sid=vendo.tv_mysessionpid() AND sc_simid=simid),0);
 IF (tmp>0) THEN
  PERFORM gms.markAnyMark(simid,1);
  RETURN TRUE;
 END IF; 

 PERFORM gms.markAnyMark(simid,0);
 RETURN FALSE;
END;
$_$;
