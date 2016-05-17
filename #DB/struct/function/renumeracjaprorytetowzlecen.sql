CREATE FUNCTION renumeracjaprorytetowzlecen(boolean, boolean, boolean, boolean, text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _bycentrala ALIAS FOR $1;
 _byrodzaj ALIAS FOR $2;
 _byosoba ALIAS FOR $3;
 _bydzial ALIAS FOR $4;
 _where ALIAS FOR $5;
 _open TEXT;
 _paramquery TEXT;
 _diffquery TEXT;
 _prioquery TEXT;
 _updquery TEXT;
BEGIN

 --warunek na otwarte zlecenia
 _open := '(zl_status&14=0 OR zl_status&14=2)';

 --konstruujemy zapytanie wyciagajace parametry roznicujace
 _paramquery = 'SELECT zl_typ AS d0,';

 IF (_bycentrala) THEN _paramquery = _paramquery || 'fm_idcentrali'; ELSE _paramquery = _paramquery || 'null::integer'; END IF;
 _paramquery = _paramquery || ' AS d1,';
 IF (_byrodzaj) THEN _paramquery = _paramquery || 'COALESCE(zl_rodzajimp,-1)'; ELSE _paramquery = _paramquery || 'null::integer'; END IF;
 _paramquery = _paramquery || ' AS d2,';
 IF (_byosoba) THEN _paramquery = _paramquery || 'p_odpowiedzialny'; ELSE _paramquery = _paramquery || 'null::integer'; END IF;
 _paramquery = _paramquery || ' AS d3,';
 IF (_bydzial) THEN _paramquery = _paramquery || 'dz_iddzialu'; ELSE _paramquery = _paramquery || 'null::integer'; END IF;
 _paramquery = _paramquery || ' AS d4';

 _paramquery = _paramquery || ' FROM tg_zlecenia WHERE ' || _open || ' AND ' || _where;

 --konstruujemy zapytanie roznicujace
 _diffquery = 'SELECT DISTINCT ON (d0,d1,d2,d3,d4) d0,d1,d2,d3,d4 FROM(' || _paramquery || ') AS x';

 --konstruujemy zapytanie wyliczajace priorytety
 _prioquery = 'SELECT d0,d1,d2,d3,d4,rn,zl_idzlecenia FROM(' || _diffquery || ') AS y JOIN(SELECT row_number() OVER(PARTITION BY zl_typ';

 IF (_bycentrala) THEN _prioquery = _prioquery || ',fm_idcentrali'; END IF;
 IF (_byrodzaj) THEN _prioquery = _prioquery || ',COALESCE(zl_rodzajimp,-1)'; END IF;
 IF (_byosoba) THEN _prioquery = _prioquery || ',p_odpowiedzialny'; END IF;
 IF (_bydzial) THEN _prioquery = _prioquery || ',dz_iddzialu'; END IF;

 _prioquery = _prioquery || ' ORDER BY zl_prorytet,zl_idzlecenia) AS rn, zl_typ,zl_idzlecenia,fm_idcentrali,COALESCE(zl_rodzajimp,-1) AS zl_rodzajimp,p_odpowiedzialny,dz_iddzialu FROM tg_zlecenia WHERE ' || _open || ' AND ' || _where || ') AS zl ON (0=0';

 _prioquery = _prioquery || ' AND zl.zl_typ=d0';
 IF (_bycentrala) THEN _prioquery = _prioquery || ' AND zl.fm_idcentrali=d1'; END IF;
 IF (_byrodzaj) THEN _prioquery = _prioquery || ' AND zl.zl_rodzajimp=d2'; END IF;
 IF (_byosoba) THEN _prioquery = _prioquery || ' AND zl.p_odpowiedzialny=d3'; END IF;
 IF (_bydzial) THEN _prioquery = _prioquery || ' AND zl.dz_iddzialu=d4'; END IF;

 _prioquery = _prioquery || ') ORDER BY d0,d1,d2,d3,d4,rn';
 
 --konstruujemy zapytanie updatujace
 _updquery = 'UPDATE tg_zlecenia SET zl_prorytet=sq.rn FROM(' || _prioquery || ') AS sq WHERE tg_zlecenia.zl_idzlecenia=sq.zl_idzlecenia AND (zl_prorytet IS DISTINCT FROM sq.rn);';
 
 --wreszcie wykonujemy zapytanie
 EXECUTE _updquery;

END;
$_$;
