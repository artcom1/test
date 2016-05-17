CREATE FUNCTION splaszczpodgrupetowarow(integer) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 r RECORD;
BEGIN
 IF ($1 IS NULL) THEN RETURN ''; END IF;
 SELECT tpg_parent, tpg_nazwa INTO r FROM tg_podgrupytow WHERE tpg_idpodgrupy=$1;
 IF (r.tpg_parent IS NULL) THEN
  return r.tpg_nazwa;
 ELSE 
  RETURN splaszczPodGrupeTowarow(r.tpg_parent)||'??'||r.tpg_nazwa;
 END IF;
END;
$_$;
