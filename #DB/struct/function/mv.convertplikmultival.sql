CREATE OR REPLACE FUNCTION 
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
  _isarray ALIAS FOR $8;
  query TEXT;
BEGIN
 PERFORM mv.convertAssertTable(_srcID,_srcType,_dstTable,_dstFKey,_fKeyTableName);

 IF (_isarray=FALSE) THEN
  query=$$UPDATE $$||_dstTable||$$ AS t SET $$||_dstFlagField||$$=(SELECT DISTINCT ((~(v_flaga&1))&1)<<1 FROM tb_multival WHERE skipit=false AND v_type=$$||_srcType||$$ AND mv_idvalue=$$||_srcID||$$ AND v_id=t.$$||_dstFKey||$$ LIMIT 1),$$;
  query=query||_dstField||$$=(SELECT DISTINCT tpl_idpliku FROM tb_multival join mv_impsavedpliki ON (tpl_ref=v_idvalue) WHERE skipit=false AND v_type=$$||_srcType||$$ AND mv_idvalue=$$||_srcID||$$ AND v_id=t.$$||_dstFKey||$$ AND tag_id in (SELECT tag_id from tb_tag where tag_datatype IN (105,297) and tag_subdatatype=9) LIMIT 1)$$;
  query=query||$$ WHERE $$||_dstFKey||$$ IN (SELECT v_id FROM tb_multival WHERE skipit=FALSE AND v_type=$$||_srcType||$$ AND mv_idvalue=$$||_srcID||$$)$$;
  RAISE NOTICE '%',query;
  EXECUTE query;

  query=$$UPDATE tg_pliki SET tpl_ref=(SELECT nmv_id FROM $$||_dstTable||$$ AS t WHERE tg_pliki.tpl_idpliku=t.$$||_dstField||$$) WHERE tpl_idpliku IN (SELECT $$||_dstField||$$ FROM $$||_dstTable||$$)$$;
  RAISE NOTICE '%',query;
  EXECUTE query;
 ELSE
  query=$$UPDATE $$||_dstTable||$$ AS t SET $$||_dstFlagField||$$=ARRAY(SELECT ((~(v_flaga&1))&1)<<1 FROM tb_multival WHERE skipit=FALSE AND v_type=$$||_srcType||$$ AND mv_idvalue=$$||_srcID||$$ AND v_id=t.$$||_dstFKey||$$ ORDER BY v_idvalue),$$;
  query=query||_dstField||$$=ARRAY(SELECT tpl_idpliku FROM tb_multival join mv_impsavedpliki ON (tpl_ref=v_idvalue) WHERE skipit=FALSE AND v_type=$$||_srcType||$$ AND mv_idvalue=$$||_srcID||$$ AND v_id=t.$$||_dstFKey||$$ AND tag_id in (SELECT tag_id from tb_tag where tag_datatype IN (105,297) and tag_subdatatype=9) )$$;
  query=query||$$WHERE $$||_dstFKey||$$ IN (SELECT v_id FROM tb_multival WHERE skipit=FALSE AND v_type=$$||_srcType||$$ AND mv_idvalue=$$||_srcID||$$ ORDER BY v_idvalue)$$;
  EXECUTE query;

  query=$$UPDATE tg_pliki SET tpl_ref=(SELECT nmv_id FROM $$||_dstTable||$$ AS t WHERE tg_pliki.tpl_idpliku=ANY(t.$$||_dstField||$$)) WHERE EXISTS (SELECT nmv_id FROM $$||_dstTable||$$ WHERE tg_pliki.tpl_idpliku = ANY ($$||_dstField||$$))$$;
  RAISE NOTICE '%',query;
  EXECUTE query;
 END IF;

 RETURN TRUE;
END; $_$;
