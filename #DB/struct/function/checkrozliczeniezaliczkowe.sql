CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idrozrachunku ALIAS FOR $1;
 tmp INT;
BEGIN
 tmp=(SELECT tr_zamknieta&1 FROM kr_rozrachunki JOIN tg_transakcje USING (tr_idtrans) WHERE rr_idrozrachunku=_idrozrachunku);
 IF (tmp=1) THEN
  tmp=(SELECT tr_idtrans FROM kr_rozrachunki WHERE rr_idrozrachunku=_idrozrachunku);
---  RAISE EXCEPTION '15|%|Nie mozna rozliczac zaliczek na zamknietym dokumencie ',tmp;
 END IF;
 
 RETURN TRUE;
END;
$_$;
