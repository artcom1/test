CREATE FUNCTION przepiszkontaktdozdarzenia(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 id_kontaktu ALIAS FOR $1; --id starego rekordu w tabeli tb_kontakt
 ret integer; --id nowego rekordu w tabeli tb_zdarzenia

 knt RECORD;
 zd RECORD;

 zdrodzaj integer;
 zdtyp integer;
 zdflaga integer;
 datazakonczenia timestamp with time zone;
 temat text;
 opis text;
 pos integer;
 pracprzyp integer;
BEGIN
	SELECT * INTO knt FROM tb_kontakt WHERE m_idkontaktu = id_kontaktu;
	IF (knt = NULL) THEN RETURN NULL;
	END IF;

	IF (knt.m_flaga&4=4 AND knt.m_wykonanie=TRUE) THEN 
		zdrodzaj = 3;
	ELSE 
		zdrodzaj = 1;
	END IF;

	zdtyp = getTypZdarzeniaByOldRodzaj(knt.rk_idrodzajkontaktu, 1);

	zdflaga = 0;
	IF (knt.m_wykonanie = NULL AND (knt.m_flaga&4)=0) THEN
	    zdflaga = 2;
	END IF;
	IF (knt.m_wykonanie = TRUE) THEN
		zdflaga=4;
	END IF;
	IF (knt.m_wykonanie = FALSE) THEN
		zdflaga=8;
	END IF;

	temat = '';
	opis = '';
	IF (zdrodzaj = 3) THEN
		pos = strpos(knt.m_opisspotkania, '\n');
		IF (pos > 0) THEN
			temat = substr(knt.m_opisspotkania, 0, pos-1);
			opis = substr(knt.m_opisspotkania, pos+1, length(knt.m_opisspotkania));
		ELSE
			temat = knt.m_opisspotkania;
		END IF;
	ELSE
		pos = strpos(knt.m_celspotkania, '\n');
		IF (pos > 0) THEN
			temat = substr(knt.m_celspotkania, 0, pos-1);
			opis = substr(knt.m_celspotkania, pos+1, length(knt.m_celspotkania));
		ELSE
			temat = knt.m_celspotkania;
		END IF;

		IF (knt.m_opisspotkania!='') THEN
			IF (opis!='') THEN
			    opis = opis||'\r\n\r\n';
			END IF;
			opis = opis||knt.m_opisspotkania;
		END IF;
		
		IF (knt.m_przyczynaniewykonania!='') THEN
			IF (opis!='') THEN
			    opis = opis||'\r\n\r\n';
			END IF;
			opis = opis||knt.m_przyczynaniewykonania;
		END IF;
	END IF;

	pracprzyp = 0;
	IF (zdrodzaj = 3) THEN
	    pracprzyp = knt.p_idpracownika;
	END IF;

	INSERT 
	INTO tb_zdarzenia 
	(p_wpisujacy, p_idpracownika, k_idklienta, lk_idczklienta, zl_idzlecenia, zd_datautworzenia, zd_datarozpoczecia,
	 zd_datazakonczenia, zd_dataprzypomnienia, zd_miejsce, zd_temat, zd_opis, zd_rodzaj, zd_typzdarzenia, zd_flaga, p_pracprzyp) 
	VALUES
	(knt.m_pwprowadzajacy, knt.p_idpracownika, knt.k_idklienta, knt.lk_idczklienta, knt.zl_idzlecenia, knt.m_datawpr, knt.m_godzinaspotkania,
	 knt.m_godzinaspotkania, knt.m_godzinaspotkania, knt.m_gdziespotkanie, temat, opis, zdrodzaj, zdtyp, zdflaga, pracprzyp);

	ret = (SELECT currval('tb_zdarzenia_s'));
	
	SELECT * INTO zd FROM tb_zdarzenia WHERE zd_idzdarzenia = ret;

	IF(zd.zd_rodzaj = 1 AND (zd.zd_flaga&2)=2) THEN
		INSERT INTO tb_pp (p_idpracownikafor, ppm_type, ppm_refid, ppm_opis, ppm_nakiedy) 
		VALUES(zd.p_idpracownika, 210, (SELECT pzd_idpracownika FROM tb_pracownicyzdarzenia WHERE zd_idzdarzenia=zd.zd_idzdarzenia AND p_idpracownika=zd.p_idpracownika), 'Kontakt: '||zd.zd_temat, zd.zd_datarozpoczecia);
	END IF;

	UPDATE tg_log SET lg_ref = ret, lg_typeref = 206 WHERE lg_ref = id_kontaktu AND lg_typeref = 29;

	RETURN ret;
END;
$_$;
