CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _mv_idvalue ALIAS FOR $1;
 _new_lp INT:=$2;
 mv1 RECORD;
 max_lp INT;
BEGIN
  SELECT mvs_id, mvs_lp, mvs_datatypefor, mvs_podrodzajfor INTO mv1 FROM mv.ts_multivals WHERE mvs_id=_mv_idvalue;

  max_lp := (SELECT mvs_lp FROM mv.ts_multivals WHERE mvs_datatypefor=mv1.mvs_datatypefor AND NullZero(mvs_podrodzajfor)=NullZero(mv1.mvs_podrodzajfor) ORDER BY mvs_lp DESC LIMIT 1);

  IF (_new_lp <= 0) THEN
    _new_lp := 1;
  END IF;
  
  IF (_new_lp > max_lp) THEN
    _new_lp := max_lp;
  END IF;

  IF (_new_lp < mv1.mvs_lp) THEN
    UPDATE mv.ts_multivals SET mvs_lp=mvs_lp+1 WHERE mvs_datatypefor=mv1.mvs_datatypefor AND NullZero(mvs_podrodzajfor)=NullZero(mv1.mvs_podrodzajfor) AND mvs_lp>=_new_lp AND mvs_lp<mv1.mvs_lp;
  ELSE
    UPDATE mv.ts_multivals SET mvs_lp=mvs_lp-1 WHERE mvs_datatypefor=mv1.mvs_datatypefor AND NullZero(mvs_podrodzajfor)=NullZero(mv1.mvs_podrodzajfor) AND mvs_lp<=_new_lp AND mvs_lp>mv1.mvs_lp;
  END IF;
  UPDATE mv.ts_multivals SET mvs_lp=_new_lp WHERE mvs_id=mv1.mvs_id;

  RETURN mv1.mvs_id;
END;
$_$;
