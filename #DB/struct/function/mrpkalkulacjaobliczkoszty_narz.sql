CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _th_idtechnologii  ALIAS FOR $1;
 _kalk_ilosc ALIAS FOR $2;
 ile NUMERIC:=0;
BEGIN 
 ile=(SELECT sum(rr.trr_cena*rr.trr_ilosckrotnosc) FROM tr_rrozchodu AS rr WHERE rr.th_idtechnologii=_th_idtechnologii AND rr.trr_wplywmag=0); 
 RETURN ile;
END;
$_$;
