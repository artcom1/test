CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _tk_idelem ALIAS FOR $1;
 _new_lp INT:=$2;
 te1 RECORD;
 max_lp INT;
BEGIN
  SELECT tk_idelem, tk_lp, tr_idtrans INTO te1 FROM tg_tkelem WHERE tk_idelem=_tk_idelem;

  max_lp := (SELECT tk_lp FROM tg_tkelem WHERE tr_idtrans=te1.tr_idtrans order by tk_lp desc limit 1);

  IF (_new_lp <= 0) THEN
    _new_lp := 1;
  END IF;
  
  IF (_new_lp > max_lp) THEN
    _new_lp := max_lp;
  END IF;
  
  IF (_new_lp < te1.tk_lp) THEN
    UPDATE tg_tkelem SET tk_lp=tk_lp+1 WHERE tr_idtrans=te1.tr_idtrans AND tk_lp>=_new_lp AND tk_lp<te1.tk_lp;
  ELSE
    UPDATE tg_tkelem SET tk_lp=tk_lp-1 WHERE tr_idtrans=te1.tr_idtrans AND tk_lp<=_new_lp AND tk_lp>te1.tk_lp;
  END IF;
  UPDATE tg_tkelem SET tk_lp=_new_lp WHERE tr_idtrans=te1.tr_idtrans AND tk_idelem=te1.tk_idelem;

  RETURN te1.tk_idelem;
END;
$_$;
