CREATE FUNCTION convertasserttable(integer, integer, text, text, text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
  _srcID ALIAS FOR $1;
  _srcType ALIAS FOR $2;
  _dstTable ALIAS FOR $3;
  _dstFKey ALIAS FOR $4;
  _fKeyTableName ALIAS FOR $5;
  query TEXT;
BEGIN
 query=$$INSERT INTO $$||_dstTable||$$ (nmv_id,$$||_dstFKey||$$) 
       SELECT nextval('mv.mvmultivalues_s'::regclass),v_id FROM (
       SELECT DISTINCT v_id FROM tb_multival AS v $$;
 
 IF (_fKeyTableName!='') THEN --''
  query=query||$$ JOIN $$||_fKeyTableName||$$ AS t ON (v.v_id=t.$$||_dstFKey||$$) $$;
 END IF;

 query=query||$$ WHERE skipit=FALSE AND mv_idvalue=$$||_srcID||$$ AND v_type=$$||_srcType||$$ AND NOT EXISTS (SELECT nmv_id FROM $$||_dstTable||$$ AS i WHERE i.$$||_dstFKey||$$=v.v_id)
 ) AS abc $$;

 RAISE NOTICE '%',query;
 EXECUTE query;

 RETURN TRUE;
END; $_$;
