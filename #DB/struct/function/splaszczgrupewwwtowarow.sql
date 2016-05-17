CREATE FUNCTION splaszczgrupewwwtowarow(integer) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 r RECORD;
BEGIN
 IF ($1 IS NULL) THEN RETURN ''; END IF;
 SELECT tgw_parent, tgw_nazwa INTO r FROM tg_grupywww WHERE tgw_idgrupy=$1;
 IF (r.tgw_parent IS NULL) THEN
  return r.tgw_nazwa;
 ELSE 
  RETURN splaszczGrupeWWWTowarow(r.tgw_parent)||'??'||r.tgw_nazwa;
 END IF;
END;
$_$;
