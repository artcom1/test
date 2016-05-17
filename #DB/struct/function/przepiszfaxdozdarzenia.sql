CREATE FUNCTION przepiszfaxdozdarzenia(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 id_archiwum ALIAS FOR $1; --id starego rekordu w tabeli tg_archiwum
 ret integer; --id nowego rekordu w tabeli tb_zdarzenia

 re RECORD;
 zdrodzaj integer;
 zdflaga integer;
 zdtyp integer;
 datazakonczenia timestamp with time zone;
 temat text;
 opis text;
 pos integer;
BEGIN	
	SELECT * INTO re FROM tg_archiwum WHERE a_idarchiwum = id_archiwum;
	IF (re = NULL) THEN RETURN NULL;
	END IF;

	zdrodzaj = 2;

	zdflaga = 0;
	
	IF(re.a_status = 0 OR re.a_status = 3) THEN zdflaga = zdflaga|(0<<2); END IF;
	IF(re.a_status = 1 OR re.a_status = 2) THEN zdflaga = zdflaga|(1<<2); END IF;
	IF(re.a_status = 4) THEN zdflaga = zdflaga|(2<<2); END IF;

	zdflaga = zdflaga|(re.a_rodzaj << 4);
	IF ((re.a_faxmail)>0) THEN
		zdflaga = zdflaga|((re.a_faxmail-1) << 5);		    
	ELSE
		zdflaga = zdflaga|(re.a_faxmail << 5);
	END IF;
	
	zdtyp = 0;
	zdtyp = getTypZdarzeniaByOldRodzaj(re.r_idrodzaju, 2);

	pos = strpos(re.a_temat, '\n');
	IF (pos > 0) THEN
	    temat = substr(re.a_temat, 0, pos-1);
	    opis = substr(re.a_temat, pos+1, length(re.a_temat));
	ELSE
	    temat = re.a_temat;
	END IF;

	INSERT 
	INTO tb_zdarzenia 
	(p_wpisujacy, p_idpracownika, k_idklienta, lk_idczklienta, zl_idzlecenia, zd_datautworzenia, zd_datarozpoczecia,
	 zd_datazakonczenia, zd_miejsce, zd_temat, zd_opis, zd_rodzaj, zd_typzdarzenia, zd_flaga, zd_prefix, zd_numer, zd_koszt, wl_idwaluty, 
	 p_pracprzyp, ob_idobiektu) 
	VALUES
	(re.p_idpracownika, re.p_idpracownika, re.k_idklienta, re.lk_idczklienta, re.zl_idzlecenia, re.a_datanadold, re.a_datanadania,
	 re.a_datanadejscia, re.a_zrodlo, temat, opis, zdrodzaj, zdtyp, zdflaga, re.a_prefix, re.a_numer, re.a_koszt, re.wl_idwaluty, 
	 re.p_idpracownika, re.a_idarchiwum);

	ret = (SELECT currval('tb_zdarzenia_s'));

	--przenosimy logi dokumentu
	UPDATE tg_log SET lg_ref = ret, lg_typeref = 206 WHERE lg_ref = id_archiwum AND lg_typeref = 33;
	--przenosimy pliki dokumentu
	UPDATE tg_pliki SET tpl_ref = ret, tpl_rodzaj = 206 WHERE tpl_ref = id_archiwum AND tpl_rodzaj = 33;
	--przenosimy wartosci dowolne dokumentu
	UPDATE tb_multival SET v_id = ret, v_type = 206 WHERE v_id = id_archiwum AND v_type = 33;

	RETURN ret;
END;
$_$;
