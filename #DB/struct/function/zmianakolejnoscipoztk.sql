CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 trans RECORD;
 lp INT;
 tr_idtrans INT;
BEGIN
  tr_idtrans=-2;
  lp=1;
  FOR trans IN EXECUTE $1 
  LOOP
    IF (trans.tr_idtrans!=tr_idtrans) THEN
     tr_idtrans=trans.tr_idtrans::INT;
     lp=1;
    END IF;
    
    UPDATE tg_tkelem SET tk_lp=lp WHERE tk_idelem=trans.tk_idelem;
    lp=lp+1;
  END LOOP;

  RETURN 1;
END;$_$;
