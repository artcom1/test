CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelem ALIAS FOR $1;
 flag INT;
 tr_idtrans INT;
BEGIN

 flag=(SELECT tr_zamknieta FROM tg_transakcje AS tr JOIN tg_transelem AS te ON (te.tr_idtrans=tr.tr_idtrans) WHERE te.tel_idelem=_idelem);

 IF ((flag&1)=1) THEN
  tr_idtrans=(SELECT te.tr_idtrans FROM tg_transelem AS te WHERE te.tel_idelem=_idelem);
  RAISE EXCEPTION '3|%:%|Dokument jest juz zamkniety!',tr_idtrans,_idelem;
  RETURN FALSE;
 END IF;

 RETURN TRUE;
END;
$_$;
