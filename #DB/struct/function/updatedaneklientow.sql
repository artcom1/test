CREATE FUNCTION updatedaneklientow(integer, integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtrans ALIAS FOR $1;
 _shouldbe1 ALIAS FOR $2;
BEGIN

 IF (_shouldbe1<>1) THEN
  RETURN FALSE;
 END IF;

 UPDATE tg_transakcje SET 
                        tr_knazwa=(SELECT k_nazwa FROM tb_klient AS k WHERE k.k_idklienta=tg_transakcje.k_idklienta),
                        tr_kadres=(SELECT getAdresKlienta(k_ulica,k_nrdomu,k_nrlokalu) FROM tb_klient AS k WHERE k.k_idklienta=tg_transakcje.k_idklienta),
                        tr_kkodpocz=(SELECT k_kodpocztowy FROM tb_klient AS k WHERE k.k_idklienta=tg_transakcje.k_idklienta),
                        tr_kmiasto=(SELECT k_miejscowosc FROM tb_klient AS k WHERE k.k_idklienta=tg_transakcje.k_idklienta),
                        tr_nip=(SELECT k_nip FROM tb_klient AS k WHERE k.k_idklienta=tg_transakcje.k_idklienta),
                        tr_onazwa=(SELECT k_nazwa FROM tb_klient AS k WHERE k.k_idklienta=tg_transakcje.tr_oidklienta),
                        tr_oadres=(SELECT getAdresKlienta(k_ulica,k_nrdomu,k_nrlokalu) FROM tb_klient AS k WHERE k.k_idklienta=tg_transakcje.tr_oidklienta),
                        tr_okodpocz=(SELECT k_kodpocztowy FROM tb_klient AS k WHERE k.k_idklienta=tg_transakcje.tr_oidklienta),
                        tr_omiasto=(SELECT k_miejscowosc FROM tb_klient AS k WHERE k.k_idklienta=tg_transakcje.tr_oidklienta),
                        tr_onip=(SELECT k_nip FROM tb_klient AS k WHERE k.k_idklienta=tg_transakcje.tr_oidklienta)
		     WHERE tr_idtrans=_idtrans;



 RETURN TRUE;
END;
$_$;
