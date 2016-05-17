CREATE FUNCTION splaszczgrupetowarow(integer) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 r RECORD;
BEGIN
 IF ($1 IS NULL) THEN RETURN ''; END IF;
 SELECT tgr_parent, tgr_nazwa INTO r FROM tg_grupytow WHERE tgr_idgrupy=$1;
 IF (r.tgr_parent IS NULL) THEN
  return r.tgr_nazwa;
 ELSE 
  RETURN splaszczGrupeTowarow(r.tgr_parent)||'??'||r.tgr_nazwa;
 END IF;
END;
$_$;
