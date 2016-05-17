CREATE FUNCTION checkflagaalgorytmuvat(integer, integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtrans       ALIAS FOR $1;
 _idrozliczenia ALIAS FOR $2;
 ile INT:=0;
BEGIN
 ile=(SELECT count(*) FROM kr_rozliczenia AS rl 
                      JOIN kr_rozrachunki AS rr ON (rl.rr_idrozrachunkul=rr.rr_idrozrachunku)
		      WHERE rr.tr_idtrans=_idtrans AND rl_flaga&130=130 AND rl_idrozliczenia<>_idrozliczenia);
 IF (ile=0) THEN
  ile=(SELECT count(*) FROM kr_rozliczenia AS rl 
                       JOIN kr_rozrachunki AS rr ON (rl.rr_idrozrachunkur=rr.rr_idrozrachunku)
 		       WHERE rr.tr_idtrans=_idtrans AND rl_flaga&129=129 AND rl_idrozliczenia<>_idrozliczenia);
 END IF;

 IF (ile=0) THEN
  UPDATE tg_transakcje SET tr_zamknieta=tr_zamknieta&(~(1<<20)) WHERE tr_idtrans=_idtrans AND (tr_zamknieta&(1<<20))=(1<<20);
  RETURN FALSE;
 ELSE
  UPDATE tg_transakcje SET tr_zamknieta=tr_zamknieta|(1<<20) WHERE tr_idtrans=_idtrans AND (tr_zamknieta&(1<<20))=0;
  RETURN TRUE;
 END IF;

 RETURN TRUE;
END;
$_$;
