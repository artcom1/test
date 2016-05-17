CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
	id_prz ALIAS FOR $1; 
	ret integer;
	
	prz record;
	zd RECORD;

	flaga integer;
	typ integer;
BEGIN
	SELECT * INTO prz FROM tg_prace WHERE pr_idpracy=id_prz;
	
	--ustalamy flage zdarzenia
	flaga = 0;
	flaga = flaga | ((prz.pr_flaga&3)<<2);
	flaga = flaga | (prz.pr_flaga&48);

	typ = 0;
	SELECT min(tsz_idtypu) INTO typ FROM ts_typzdarzenia WHERE zd_rodzaj = 4;

	INSERT INTO tb_zdarzenia (zl_idzlecenia, p_wpisujacy, p_idpracownika, k_idklienta, zd_rodzaj, zd_typzdarzenia, zd_opis, zd_datarozpoczecia, zd_datazakonczenia, zd_flaga, ob_idobiektu) 
	VALUES(prz.zl_idzlecenia, prz.p_idpracownika, prz.p_idpracownika, prz.k_idklienta, 4, typ, prz.pr_opispracy, prz.pr_datapracy, prz.pr_datapracy, flaga, prz.ob_idobiektu);

	ret = (SELECT currval('tb_zdarzenia_s'));

	UPDATE tg_log SET lg_ref=ret, lg_typeref=206 WHERE lg_ref=id_prz AND lg_typeref=54;	

	RETURN ret;
END;
$_$;
