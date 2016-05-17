CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idpartii ALIAS FOR $1;
 _bylo     ALIAS FOR $2;
 _jest     ALIAS FOR $3;
 _byloc    ALIAS FOR $4;
 _jestc    ALIAS FOR $5;
BEGIN
 _byloc=min(_byloc,1);
 _jestc=min(_jestc,1);

 IF (_bylo=0) AND (_jest=0) AND (_byloc=_jestc) THEN
  RETURN TRUE;
 END IF;
 IF (_bylo>0) AND (_jest>0) AND (_byloc=_jestc) THEN
  RETURN TRUE;
 END IF;

 IF (_jest>0) THEN
  UPDATE tg_partie SET prt_hasanystan=TRUE,prt_tmnotzerocount=prt_tmnotzerocount+(_jestc-_byloc) WHERE prt_idpartii=_idpartii AND (prt_hasanystan=FALSE OR _jestc!=_byloc);
  RETURN TRUE;
 END IF;

 UPDATE tg_partie 
 SET prt_hasanystan=FALSE 
 WHERE prt_hasanystan=TRUE AND 
       prt_idpartii=_idpartii AND NOT EXISTS
       (
        SELECT ptm_id
        FROM tg_partietm AS r 
	    WHERE r.prt_idpartii=_idpartii AND
	          r.ptm_stanmag>0
       );
 
 ---Ilosc rekordow w tg_partietm 
 IF (_byloc!=_jestc) THEN
  UPDATE tg_partie SET prt_tmnotzerocount=prt_tmnotzerocount+(_jestc-_byloc) WHERE prt_idpartii=_idpartii;
 END IF; 
 
 RETURN TRUE;
END;
$_$;
