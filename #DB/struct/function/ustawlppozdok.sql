CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _tel_idelem ALIAS FOR $1;
 _new_lp INT:=$2;
 te1 RECORD;
 max_lp INT;
BEGIN
  SELECT tel_idelem, tel_lp, tel_lpprefix, tr_idtrans INTO te1 FROM tg_transelem WHERE tel_idelem=_tel_idelem;

  max_lp := (SELECT tel_lp FROM tg_transelem WHERE tr_idtrans=te1.tr_idtrans AND tel_lpprefix=te1.tel_lpprefix order by tel_lp desc limit 1);

  IF (_new_lp <= 0) THEN
    _new_lp := 1;
  END IF;
  
  IF (_new_lp > max_lp) THEN
    _new_lp := max_lp;
  END IF;
  
  IF (_new_lp < te1.tel_lp) THEN
    UPDATE tg_transelem SET tel_flaga=tel_flaga|16384, tel_lp=tel_lp+1 WHERE tr_idtrans=te1.tr_idtrans AND tel_lp>=_new_lp AND tel_lp<te1.tel_lp  AND tel_lpprefix=te1.tel_lpprefix;
  ELSE
    UPDATE tg_transelem SET tel_flaga=tel_flaga|16384, tel_lp=tel_lp-1 WHERE tr_idtrans=te1.tr_idtrans AND tel_lp<=_new_lp AND tel_lp>te1.tel_lp  AND tel_lpprefix=te1.tel_lpprefix;
  END IF;
  UPDATE tg_transelem SET tel_flaga=tel_flaga|16384, tel_lp=_new_lp WHERE tr_idtrans=te1.tr_idtrans AND tel_idelem=te1.tel_idelem  AND tel_lpprefix=te1.tel_lpprefix;

  PERFORM dorenumerujtrans(te1.tr_idtrans);

  RETURN te1.tel_idelem;
END;
$_$;
