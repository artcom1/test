CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtrans ALIAS FOR $1;
 lp INT:=1;
 rec RECORD;
BEGIN
 FOR rec IN SELECT tr_idtrans,tk_idelem,tk_lp FROM tg_transakcje JOIN tg_tkelem USING (tr_idtrans) WHERE tr_zamknieta&12::int2=0 AND tg_transakcje.tr_idtrans IN (_idtrans) ORDER BY tr_idtrans,tk_lp FOR UPDATE
 LOOP
  UPDATE tg_tkelem SET tk_lp=lp WHERE tk_idelem=rec.tk_idelem AND tk_lp<>lp;
  lp=lp+1;
 END LOOP;

 RETURN 0;
END;
$_$;
