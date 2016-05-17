CREATE FUNCTION convertsimplemultival(integer, integer, text, text, text, text, text, text, boolean, text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
  _srcID ALIAS FOR $1;
  _srcType ALIAS FOR $2;
  _dstTable ALIAS FOR $3;
  _dstFKey ALIAS FOR $4;
  _dstField ALIAS FOR $5;
  _dstFlagField ALIAS FOR $6;
  _fKeyTableName ALIAS FOR $7;
  _dstFieldType ALIAS FOR $8;
  _isarray ALIAS FOR $9;
  _addfield ALIAS FOR $10;
  query TEXT;
BEGIN
 PERFORM mv.convertAssertTable(_srcID,_srcType,_dstTable,_dstFKey,_fKeyTableName);

 IF (_isarray=FALSE) THEN
  query=$$UPDATE $$||_dstTable||$$ AS t SET $$||_dstFlagField||$$=(SELECT DISTINCT ((~(v_flaga&1))&1)<<1 FROM tb_multival WHERE skipit=false AND v_type=$$||_srcType||$$ AND mv_idvalue=$$||_srcID||$$ AND v_id=t.$$||_dstFKey||$$ LIMIT 1),$$;
  query=query||_dstField||$$=(SELECT DISTINCT v_value::$$||_dstFieldType||$$ FROM tb_multival WHERE skipit=false AND v_type=$$||_srcType||$$ AND mv_idvalue=$$||_srcID||$$ AND v_id=t.$$||_dstFKey||$$ LIMIT 1)$$;
  IF (_addfield<>'') THEN --''
   query=query||$$,$$||_addfield||$$=(SELECT DISTINCT v_valueadd FROM tb_multival WHERE skipit=false AND v_type=$$||_srcType||$$ AND mv_idvalue=$$||_srcID||$$ AND v_id=t.$$||_dstFKey||$$ LIMIT 1)$$;
  END IF;
  query=query||$$ WHERE $$||_dstFKey||$$ IN (SELECT v_id FROM tb_multival WHERE skipit=FALSE AND v_type=$$||_srcType||$$ AND mv_idvalue=$$||_srcID||$$)$$;
  RAISE NOTICE '%',query;
  EXECUTE query;
  RETURN TRUE;
 END IF;

 query=$$UPDATE $$||_dstTable||$$ AS t SET $$||_dstFlagField||$$=ARRAY(SELECT ((~(v_flaga&1))&1)<<1 FROM tb_multival WHERE skipit=FALSE AND v_type=$$||_srcType||$$ AND mv_idvalue=$$||_srcID||$$ AND v_id=t.$$||_dstFKey||$$ ORDER BY v_idvalue),$$;
 query=query||_dstField||$$=ARRAY(SELECT v_value::$$||_dstFieldType||$$ FROM tb_multival WHERE skipit=FALSE AND v_type=$$||_srcType||$$ AND mv_idvalue=$$||_srcID||$$ AND v_id=t.$$||_dstFKey||$$)$$;
 IF (_addfield<>'') THEN --''
  query=query||_addfield||$$=ARRAY(SELECT DISTINCT v_valueadd FROM tb_multival WHERE skipit=false AND v_type=$$||_srcType||$$ AND mv_idvalue=$$||_srcID||$$ AND v_id=t.$$||_dstFKey||$$ LIMIT 1)$$;
 END IF;
 query=query||$$WHERE $$||_dstFKey||$$ IN (SELECT v_id FROM tb_multival WHERE skipit=FALSE AND v_type=$$||_srcType||$$ AND mv_idvalue=$$||_srcID||$$ ORDER BY v_idvalue)$$;
 RAISE NOTICE '%',query;
 EXECUTE query;
 RETURN TRUE;

 RETURN TRUE;
END;
$_$;
