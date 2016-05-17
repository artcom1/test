CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelem ALIAS FOR $1;
 _ile ALIAS FOR $2;
 rec RECORD;
BEGIN

 SELECT tel_lp,tr_idtrans, tel_lpprefix INTO rec FROM tg_transelem WHERE tel_idelem=_idelem FOR UPDATE;
 IF (NOT FOUND) THEN RETURN 0; END IF;
 
 UPDATE tg_transelem SET tel_lp=tel_lp+_ile,tel_flaga=tel_flaga|16384 WHERE tr_idtrans=rec.tr_idtrans AND tel_lp>rec.tel_lp AND tel_lpprefix=rec.tel_lpprefix;

 PERFORM dorenumerujtrans(rec.tr_idtrans);
 RETURN 1;
END;
$_$;
