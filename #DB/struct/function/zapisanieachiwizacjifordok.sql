CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _tr_idtrans    ALIAS FOR $1;
 _tr_plikwydruku  ALIAS FOR $2;
BEGIN
 UPDATE tg_transakcje SET tr_zamknieta=tr_zamknieta|16384, tr_plikwydruku=_tr_plikwydruku WHERE tr_idtrans=_tr_idtrans;
 RETURN 1;
END;
$_$;
