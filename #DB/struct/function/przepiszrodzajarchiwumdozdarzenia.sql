CREATE FUNCTION przepiszrodzajarchiwumdozdarzenia(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 id_rodzaju ALIAS FOR $1; --id starego rodzaju kontaktu
 ret integer; --id nowego typu zdarzenia odpowiadajacego staremu rodzajowi kontaktu
 nazwa text;
 arch record;
BEGIN
	SELECT * INTO arch FROM ts_rodzajarchiwum WHERE r_idrodzaju = id_rodzaju;
	IF (arch = NULL) THEN RETURN NULL;
	END IF;
	
	nazwa = arch.r_nazwa;
	IF (nazwa = '') THEN nazwa = 'Brak';
	END IF;

	INSERT INTO ts_typzdarzenia (tsz_nazwatypu, zd_rodzaj, tsz_oldid) VALUES(nazwa, 2, arch.r_idrodzaju);
	
	ret = (SELECT currval('ts_typzdarzenia_s'));
	
	--uaktualniamy tabele ts_seriepracownikow zmeiniajac rodzaje archiwow na typy zdarzen
	UPDATE ts_seriepracownikow SET r_idrodzaju = ret WHERE r_idrodzaju = id_rodzaju;

	--uaktulaniamy tabele pracownikow w polu z domyslnym typem zdarzenia (dawniej rodzajem archiwum) - p_sekretariat
	UPDATE tb_pracownicy SET p_sekretariat = ret WHERE p_sekretariat = id_rodzaju;

	RETURN ret;
END;
$_$;
