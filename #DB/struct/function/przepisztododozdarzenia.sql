CREATE FUNCTION przepisztododozdarzenia(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 id_todo ALIAS FOR $1; --id starego rekordu w tabeli tb_todo
 ret integer; --id nowego rekordu w tabeli tb_zdarzenia

 td RECORD;
 zd RECORD;

 zdrodzaj integer;
 zdflaga integer;
 zdtyp integer;
 datazakonczenia timestamp with time zone;
BEGIN
	SELECT * INTO td FROM tb_todo WHERE td_idtodo = id_todo;
	IF (td = NULL) THEN RETURN NULL;
	END IF;

	zdrodzaj = 5;

	zdflaga = 0;
	IF (td.td_status = 1) THEN
		zdflaga = zdflaga|4;
	ELSE
		zdflaga = zdflaga|2;
	END IF;
	
	IF (td.td_datawyk = NULL) THEN
	    datazakonczenia = td.td_nakiedy;
	ELSE
	    datazakonczenia = td.td_datawyk;
	END IF;

	SELECT min(tsz_idtypu) INTO zdtyp FROM ts_typzdarzenia WHERE zd_rodzaj = zdrodzaj;

	INSERT 
	INTO tb_zdarzenia 
	(p_wpisujacy, p_idpracownika, zl_idzlecenia, zd_datautworzenia, zd_datarozpoczecia, zd_datazakonczenia, zd_dataprzypomnienia,
	 zd_temat, zd_opis, zd_rodzaj, zd_flaga, zd_typzdarzenia) 
	VALUES
	(td.td_zlecajacy, td.td_komu, td.zl_idzlecenia, td.td_datawpr, td.td_nakiedy, datazakonczenia, td.td_nakiedy,
	 td.td_opis, td.td_odpowiedz, zdrodzaj, zdflaga, zdtyp);

	ret = (SELECT currval('tb_zdarzenia_s'));

	SELECT * INTO zd FROM tb_zdarzenia WHERE zd_idzdarzenia = ret;

	IF((zd.zd_flaga&12) = 0) THEN
		INSERT INTO tb_pp (p_idpracownikafor, ppm_type, ppm_refid, ppm_opis, ppm_nakiedy) VALUES(zd.p_idpracownika, 210, (SELECT pzd_idpracownika FROM tb_pracownicyzdarzenia WHERE zd_idzdarzenia=zd.zd_idzdarzenia AND p_idpracownika=zd.p_idpracownika), 'Zadanie: '||zd.zd_temat, zd.zd_datarozpoczecia);
	END IF;

	UPDATE tg_log SET lg_ref = ret, lg_typeref = 206 WHERE lg_ref = id_todo AND lg_typeref = 28;

	RETURN ret;
END;
$_$;
