CREATE FUNCTION mrpkalkulacjaupdateilosci_mat(integer, numeric) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _th_idtechnologii  ALIAS FOR $1;
 _kalk_ilosc ALIAS FOR $2; 
BEGIN 
 UPDATE tr_rrozchodu SET trr_iloscl=(trr_ilosclalt/trr_iloscm)*_kalk_ilosc WHERE trr_iloscm<>0 AND th_idtechnologii=_th_idtechnologii AND trr_wplywmag=-1;  
 RETURN 1;
END;
$_$;
