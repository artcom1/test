CREATE FUNCTION rozrachunekdozdarzenia(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
	idrozrachunku ALIAS FOR $1;	
	ret integer;
	rr record;
	zd record;
BEGIN
	SELECT * INTO rr FROM kr_rozrachunki WHERE rr_idrozrachunku=idrozrachunku;

	IF((rr.rr_flaga&7)!=0) THEN
		RETURN FALSE;
	END IF;

	IF((SELECT tr_zamknieta&32 FROM tg_transakcje WHERE tr_idtrans=rr.tr_idtrans)=0) THEN
		RETURN FALSE;
	END IF;

	FOR zd IN 
		SELECT zd_idzdarzenia FROM tb_zdpowiazania AS zp JOIN tb_zdarzenia AS zda USING (zd_idzdarzenia) LEFT JOIN tg_transakcje AS tr ON (zp.zp_idref=tr.tr_idtrans) WHERE zp_idref=rr.tr_idtrans AND zp_datatype = 8 AND (zda.zd_flaga&896)=(1<<7)
	LOOP
		INSERT INTO tb_zdpowiazania(zd_idzdarzenia, zp_idref, zp_datatype) VALUES(zd.zd_idzdarzenia, rr.rr_idrozrachunku, 219);
	END LOOP;

	RETURN TRUE;
END;
$_$;
