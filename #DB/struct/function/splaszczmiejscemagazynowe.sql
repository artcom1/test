CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 r RECORD;
BEGIN
 IF ($1 IS NULL) THEN RETURN ''; END IF;
 SELECT mm_parent, mm_kod INTO r FROM ts_miejscamagazynowe WHERE mm_idmiejsca=$1;
 IF (r.mm_parent IS NULL) THEN
  return r.mm_kod;
 ELSE 
  RETURN splaszczMiejsceMagazynowe(r.mm_parent)||'-'||r.mm_kod;
 END IF;
END;
$_$;
