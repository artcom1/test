CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _method      ALIAS FOR $1; --- Metoda rozchodowania
 _tablealias  ALIAS FOR $2; --- Alias tg_ruchy (przyjecie)
 _ptablealias ALIAS FOR $3; --- ALIAS tg_ruchy.tg_partie
 _reverse     ALIAS FOR $4; --- Odwrotnie ?
 tmp          INT;
 ret          TEXT;
BEGIN

 IF ((_method>>8)!=0) THEN
  IF (_tablealias IS NULL) THEN
   RETURN gm.getinoutsortclause(_method&255,_tablealias,_ptablealias,_reverse);
  END IF;
  IF (_reverse=TRUE) THEN
   RETURN _tablealias||'.mm_idmiejsca IS DISTINCT FROM '||_tablealias||'stm.mm_idmiejsca DESC,'||gm.getinoutsortclause(_method&255,_tablealias,_ptablealias,_reverse);
  END IF;
  RETURN _tablealias||'.mm_idmiejsca IS NOT DISTINCT FROM COALESCE('||_tablealias||'stm.mm_idmiejsca,-1) DESC,'||gm.getinoutsortclause(_method&255,_tablealias,_ptablealias,_reverse);
 END IF;

 -------------------------------------------------------------------------------------------
 --- LEFO ----------------------------------------------------------------------------------
 -------------------------------------------------------------------------------------------
 IF (_method=3) THEN
  RETURN gm.getInOutSortClause(2,_tablealias,_ptablealias,NOT _reverse);
 END IF;
 -------------------------------------------------------------------------------------------
 --- FEFO ----------------------------------------------------------------------------------
 -------------------------------------------------------------------------------------------
 IF (_method=2) THEN
  IF (_reverse=TRUE) THEN
   RETURN _ptablealias||'.prt_datawazn DESC NULLS FIRST,'||gm.getInOutSortClause(0,_tablealias,_ptablealias,_reverse);
  END IF;
  RETURN _ptablealias||'.prt_datawazn ASC NULLS LAST,'||gm.getInOutSortClause(0,_tablealias,_ptablealias,_reverse);
 END IF;
 -------------------------------------------------------------------------------------------
 --- LIFO ----------------------------------------------------------------------------------
 -------------------------------------------------------------------------------------------
 IF (_method=1) THEN
  RETURN gm.getInOutSortClause(0,_tablealias,_ptablealias,NOT _reverse);
 END IF;

 -------------------------------------------------------------------------------------------
 --- Domyslnie FIFO ------------------------------------------------------------------------
 -------------------------------------------------------------------------------------------
 IF (_tablealias IS NULL) THEN
  RETURN _ptablealias||'.prt_idpartii';
 END IF;


 IF (_reverse=TRUE) THEN
  RETURN _tablealias||'.rc_data DESC,'||_tablealias||'.rc_dataop DESC,'||_tablealias||'.rc_dostawa DESC';
 END IF;

 RETURN _tablealias||'.rc_data ASC,'||_tablealias||'.rc_dataop ASC,'||_tablealias||'.rc_dostawa ASC';
END; 
$_$;
