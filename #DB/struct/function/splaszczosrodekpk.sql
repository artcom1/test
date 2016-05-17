CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 opk RECORD;
BEGIN

 IF ($1 IS NULL) THEN RETURN ''; END IF;
 SELECT opk_parent, opk_nazwa INTO opk FROM ts_osrodkipk WHERE opk_idosrodka=$1;
 IF (opk.opk_parent IS NULL) THEN
  return opk.opk_nazwa;
 ELSE 
  RETURN splaszczOsrodekPK(opk.opk_parent)||'??'||opk.opk_nazwa;
 END IF;
END;
$_$;
