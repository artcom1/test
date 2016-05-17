CREATE FUNCTION checkzaksiegowaniedoc(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtrans INT;
BEGIN
 
 _idtrans=(SELECT tr_idtrans FROM tg_transakcje WHERE tr_idtrans=$1 AND (tr_flaga&(1<<15)<>0) AND tr_rodzaj NOT IN (104));

 IF (_idtrans IS NOT NULL) THEN
  RAISE EXCEPTION '6|%|Dokument jest juz zaksiegowany',_idtrans;
 END IF;

 _idtrans=(SELECT tr_skojlog FROM tg_transakcje WHERE tr_idtrans=$1 AND tr_rodzaj NOT IN (104));

 IF (_idtrans IS NOT NULL) THEN
  PERFORM checkZaksiegowanieDoc(_idtrans);
 END IF;

 RETURN TRUE;
END;
$_$;
