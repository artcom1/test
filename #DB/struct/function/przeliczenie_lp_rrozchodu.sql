CREATE FUNCTION przeliczenie_lp_rrozchodu(integer, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _th_idtechnologii ALIAS FOR $1;
 _trr_wplywmag ALIAS FOR $2;
 lp INT:=1;
 _rec RECORD;
BEGIN

 FOR _rec IN SELECT trr_idelemu FROM tr_rrozchodu WHERE th_idtechnologii=_th_idtechnologii AND trr_wplywmag=_trr_wplywmag ORDER BY trr_idelemu ASC
 LOOP
  UPDATE tr_rrozchodu SET trr_lp=lp WHERE trr_idelemu=_rec.trr_idelemu;
  lp=lp+1;
 END LOOP;

 RETURN lp;
END;
$_$;
