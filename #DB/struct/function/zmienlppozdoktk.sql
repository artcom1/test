CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _tk_idelem ALIAS FOR $1;
 typ ALIAS FOR $2;
 te RECORD;
 te2 RECORD;
 query TEXT;
 wynik INT:=0;
BEGIN
  SELECT tk_idelem, tk_lp, tr_idtrans INTO te FROM tg_tkelem WHERE tk_idelem=_tk_idelem;

  IF (typ) THEN
   query='SELECT tk_idelem, tk_lp  FROM tg_tkelem WHERE tr_idtrans='||te.tr_idtrans||' AND tk_lp='||te.tk_lp-1||' AND tk_lp>0 ORDER BY tk_lp DESC';
  ELSE
   query='SELECT tk_idelem, tk_lp  FROM tg_tkelem WHERE tr_idtrans='||te.tr_idtrans||' AND tk_lp='||te.tk_lp+1||' AND tk_lp>0 ORDER BY tk_lp ASC';
  END IF;

 FOR te2 IN EXECUTE query
 LOOP
   IF (wynik=0) THEN
    wynik=te2.tk_idelem;
    UPDATE tg_tkelem SET tk_lp=te2.tk_lp WHERE tr_idtrans=te.tr_idtrans AND tk_lp=te.tk_lp;
   END IF;
   UPDATE tg_tkelem SET tk_lp=te.tk_lp WHERE tr_idtrans=te.tr_idtrans AND tk_idelem=te2.tk_idelem;
 END LOOP;

 RETURN wynik;
END;
$_$;
