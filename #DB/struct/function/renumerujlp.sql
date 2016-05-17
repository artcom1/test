CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtrans ALIAS FOR $1;
 r RECORD;
 lp INT:=0;
BEGIN

 FOR r IN SELECT fv.tel_idelem FROM tg_transelem AS fv 
          LEFT OUTER JOIN (
	  SELECT DISTINCT ON (e.tel_skojlog) e.tr_idtrans,e.tel_skojlog,e.tel_idelem,e.tel_lp FROM tg_transelem AS e
	  JOIN tg_transelem AS fe ON (e.tel_skojlog=fe.tel_idelem)
	  WHERE fe.tr_idtrans=_idtrans
	  ORDER BY e.tel_skojlog,e.tr_idtrans,e.tel_lp
	  ) AS wz ON (wz.tel_skojlog=fv.tel_idelem) 
	  WHERE 
	  fv.tr_idtrans=_idtrans 
	  ORDER BY wz.tr_idtrans,wz.tel_lp,fv.tel_lp
 LOOP  
  lp=lp+1;
  UPDATE tg_transelem SET tel_lp=lp WHERE tel_idelem=r.tel_idelem AND tel_lp<>lp;
 END LOOP;

 PERFORM dorenumerujtrans(_idtrans);
 RETURN lp;
END;
$_$;
