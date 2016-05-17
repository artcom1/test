CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _mv_idvalue ALIAS FOR $1;
 _new_kolejnosc INT:=$2;
 recat1 RECORD;
BEGIN

  SELECT mv2.mvs_lp INTO recat1 FROM mv.ts_multivals AS mv1 LEFT OUTER JOIN mv.ts_multivals AS mv2 ON (nullzero(mv1.mvs_datatypefor)=nullzero(mv2.mvs_datatypefor) AND nullzero(mv1.mvs_podrodzajfor)=nullzero(mv2.mvs_podrodzajfor)) WHERE mv1.mvs_id=_mv_idvalue ORDER BY mv2.mvs_lp OFFSET _new_kolejnosc LIMIT 1;

  IF FOUND THEN
    PERFORM ustawLPMVMultiVal(_mv_idvalue, recat1.mvs_lp);
    RETURN TRUE;
  END IF;

  RETURN FALSE;
END;
$_$;
