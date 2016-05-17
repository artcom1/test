CREATE FUNCTION rozpiszwymiarykh(integer, integer, integer, integer, numeric, numeric, boolean, boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _zp_idelemu  ALIAS FOR $1;
 _miesiac     ALIAS FOR $2;
 _kt_idkonta  ALIAS FOR $3;
 _idwaluty    ALIAS FOR $4;
 _zp_kwotawal ALIAS FOR $5;
 _zp_kwotapln ALIAS FOR $6;
 _iswn        ALIAS FOR $7;
 _isbufor     ALIAS FOR $8;
 r RECORD;
BEGIN
 
 IF (_kt_idkonta IS NULL) THEN 
  DELETE FROM kh_wymiarysumvalues WHERE zp_idelzapisu=_zp_idelemu;
  RETURN NULL;
 END IF;

 DELETE FROM kh_wymiarysumvalues WHERE zp_idelzapisu=_zp_idelemu AND kt_idkonta<>_kt_idkonta;

 RAISE NOTICE 'Mam % % ',_zp_idelemu,_kt_idkonta;

 FOR r IN SELECT *,k.wms_idwymiaru AS wms_idwymiaru_k
          FROM (SELECT * FROM kh_wymiarysumvalues WHERE zp_idelzapisu=_zp_idelemu) AS s 
	  FULL JOIN (SELECT * FROM kh_wymiaryonkonto WHERE kt_idkonta=_kt_idkonta) AS k 
	  ON (s.wms_idwymiaru=k.wms_idwymiaru AND 
	      s.kt_idkonta=k.kt_idkonta
             )
 LOOP
  ---------------------------------------------------------------------------
  IF (r.wmk_idelemu IS NULL) THEN
----   RAISE NOTICE 'Kasuje ';
   DELETE FROM kh_wymiarysumvalues WHERE wmm_idsumy=r.wmm_idsumy;
   CONTINUE;
  END IF;
  ---------------------------------------------------------------------------
  IF (r.wmm_idsumy IS NOT NULL) THEN
   IF (r.wl_idwaluty=_idwaluty) THEN
----    RAISE NOTICE 'Update ';
    UPDATE kh_wymiarysumvalues SET
           wmm_valuewnwal=(CASE WHEN _iswn THEN _zp_kwotawal ELSE 0 END),
  	   wmm_valuemawal=(CASE WHEN _iswn THEN 0 ELSE _zp_kwotawal END),
           wmm_valuewn=(CASE WHEN _iswn THEN _zp_kwotapln ELSE 0 END),
	   wmm_valuema=(CASE WHEN _iswn THEN 0 ELSE _zp_kwotapln END),
	   mc_miesiac=_miesiac,
	   wmm_isbufor=_isbufor
    WHERE wmm_idsumy=r.wmm_idsumy;
    CONTINUE;
   END IF;
   DELETE FROM kh_wymiarysumvalues WHERE wmm_idsumy=r.wmm_idsumy;
  END IF;
  
---  RAISE NOTICE 'INSERT ';

  INSERT INTO kh_wymiarysumvalues
              (kt_idkonta,zp_idelzapisu,wms_idwymiaru,wl_idwaluty,wmm_valuewnwal,wmm_valuemawal,wmm_valuewn,wmm_valuema,mc_miesiac,wmm_isbufor,wmm_optional)
	      VALUES
	      (_kt_idkonta,_zp_idelemu,r.wms_idwymiaru_k,_idwaluty,
	       (CASE WHEN _iswn THEN _zp_kwotawal ELSE 0 END),(CASE WHEN _iswn THEN 0 ELSE _zp_kwotawal END),
	       (CASE WHEN _iswn THEN _zp_kwotapln ELSE 0 END),(CASE WHEN _iswn THEN 0 ELSE _zp_kwotapln END),
	       _miesiac,
	       _isbufor,
		   (SELECT wmk_optional FROM kh_wymiaryonkonto WHERE kt_idkonta=_kt_idkonta AND wms_idwymiaru=r.wms_idwymiaru_k)
              );
 END LOOP;

 RETURN nullZero((SELECT count(*) FROM kh_wymiarysumvalues WHERE zp_idelzapisu=_zp_idelemu AND wmm_optional=FALSE AND (wmm_valuerestwnwal!=0 OR wmm_valuerestmawal!=0 OR wmm_valuerestwn!=0 OR wmm_valuerestma!=0)));
END;
$_$;
