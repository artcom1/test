CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtrans ALIAS FOR $1;
BEGIN
 --- Skasuj poprzednie rozliczenia
 DELETE FROM tb_vatzal WHERE vz_isleft IS NOT NULL AND 
                             tr_idtrans=_idtrans AND
			     EXISTS (SELECT rl_idrozliczenia FROM kr_rozliczenia AS rl WHERE rl_flaga&128=128 AND rl.rl_idrozliczenia=tb_vatzal.rl_idrozliczenia);
 --- Porusz jeszcze raz
 UPDATE kr_rozliczenia SET rl_idrozliczenia=rl_idrozliczenia
                       WHERE rl_flaga&130=130 AND
		             rr_idrozrachunkul IN (SELECT rr_idrozrachunku FROM kr_rozrachunki WHERE tr_idtrans=_idtrans);
 UPDATE kr_rozliczenia SET rl_idrozliczenia=rl_idrozliczenia
                       WHERE rl_flaga&129=129 AND
		             rr_idrozrachunkur IN (SELECT rr_idrozrachunku FROM kr_rozrachunki WHERE tr_idtrans=_idtrans);
 RETURN TRUE;
END;
$_$;
