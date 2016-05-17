CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
	id_etapu ALIAS FOR $1; 
	ret integer;
	
	etap record;
	zd RECORD;
	dok RECORD;
	zlecenie RECORD;
	
	cnt integer;
	flaga integer;
	rodzaj integer;
	typ integer;
	datazakonczenia timestamp with time zone;
	dataprzypomnienia timestamp with time zone;
	pracprzyp integer;

	pp_datatype integer;
	pp_refid integer;

	temat text;
	opis text;
	pos integer;
BEGIN
	SELECT * INTO etap FROM tg_etapyzlecen WHERE sz_idetapu=id_etapu;
	SELECT * INTO zlecenie FROM tg_zlecenia WHERE zl_idzlecenia=etap.zl_idzlecenia;
	
	--ustalamy flage zdarzenia
	flaga = 1;
	flaga = flaga | (etap.sz_status << 2);

	--data zakonczenia
	IF (etap.sz_datawykonania = NULL) THEN
		datazakonczenia = etap.sz_data;
	ELSE
		datazakonczenia = etap.sz_datawykonania;
	END IF;

	--przypominacz
	pracprzyp = 0;
	SELECT count(*) INTO cnt FROM tb_pp WHERE ppm_refid=etap.sz_idetapu AND ppm_type=57 AND ppm_flaga=0;
	IF (cnt > 0 AND (flaga&12)=0) THEN
		flaga = flaga | 2;
		SELECT ppm_nakiedy, p_idpracownikafor INTO dataprzypomnienia, pracprzyp FROM tb_pp WHERE ppm_refid=etap.sz_idetapu AND ppm_type=57 AND ppm_flaga=0;
	ELSE
		dataprzypomnienia = NULL;
	END IF;

	rodzaj = 1;
	SELECT szl_zd_rodzaj INTO rodzaj FROM ts_statuszlecenia	WHERE szl_idstatusu = etap.szl_idstatusu;
	typ = 0;
	SELECT cf_defvalue::int4 INTO typ FROM tc_config WHERE cf_tabela ILIKE 'typzd_'||rodzaj LIMIT 1;

	--temat i opis
	pos = strpos(etap.sz_komentarz, '
');
	IF (pos > 0) THEN
		temat = substr(etap.sz_komentarz, 0, pos-1);
		opis = substr(etap.sz_komentarz, pos+1, length(etap.sz_komentarz));
	ELSE
		temat = etap.sz_komentarz;
		opis = '';
	END IF;

	INSERT INTO tb_zdarzenia (zl_idzlecenia, p_wpisujacy, p_idpracownika, p_pracprzyp, k_idklienta, zd_rodzaj, zd_typzdarzenia, szl_idstatusu, zd_temat, zd_opis, zd_datarozpoczecia, zd_datazakonczenia, zd_dataprzypomnienia, zd_flaga) 
	VALUES(etap.zl_idzlecenia, etap.p_idpracownika, etap.p_idpracownika, pracprzyp, zlecenie.k_idklienta, rodzaj, typ, etap.szl_idstatusu, temat, opis, etap.sz_data, datazakonczenia, dataprzypomnienia, flaga);

	ret = (SELECT currval('tb_zdarzenia_s'));

	SELECT * INTO zd FROM tb_zdarzenia WHERE zd_idzdarzenia = ret;

	--przypominacz
	IF ((SELECT cf_defvalue FROM tc_config WHERE cf_tabela='zd_czyprzyp_auto_'||zd.zd_rodzaj LIMIT 1) = '1') THEN
		pp_datatype = 210;
		SELECT pzd_idpracownika INTO pp_refid FROM tb_pracownicyzdarzenia WHERE zd_idzdarzenia=zd.zd_idzdarzenia AND p_idpracownika=zd.p_idpracownika;
	ELSE
		pp_datatype = 206;
		pp_refid = zd.zd_idzdarzenia;
	END IF;

	UPDATE tb_pp 
	SET	ppm_type = pp_datatype, 
		ppm_refid = pp_refid
	WHERE ppm_refid = etap.sz_idetapu AND ppm_type = 57;

	--dokumenty na zdarzeniu
	FOR dok IN SELECT pde_idpodczepienia FROM tg_podczepieniadoetapow AS pd WHERE pd.sz_idetapu = etap.sz_idetapu
	LOOP
		PERFORM podczEtapuToPodczZd(dok.pde_idpodczepienia, zd.zd_idzdarzenia);
	END LOOP;

	IF((SELECT sz_idetapu FROM tg_zlecenia WHERE zl_idzlecenia=etap.zl_idzlecenia) = etap.sz_idetapu) THEN
		UPDATE tg_zlecenia SET sz_idetapu=zd.zd_idzdarzenia WHERE zl_idzlecenia=etap.zl_idzlecenia;
	END IF;

	UPDATE tg_log SET lg_ref=ret, lg_typeref=206 WHERE lg_ref=id_etapu AND lg_typeref=57;

	RETURN ret;
END;
$_$;
