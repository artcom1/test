CREATE FUNCTION przepiszrodzajkontaktudozdarzenia(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 id_rodzaju ALIAS FOR $1; --id starego rodzaju kontaktu
 ret integer; --id nowego typu zdarzenia odpowiadajacego staremu rodzajowi kontaktu
 nazwa text;
 knt record;
BEGIN
	SELECT * INTO knt FROM ts_rodzajkontaktu WHERE rk_idrodzajkontaktu = id_rodzaju;
	IF (knt = NULL) THEN RETURN NULL;
	END IF;

	nazwa = knt.rk_opis;
	IF (nazwa = '') THEN nazwa = 'Brak';
	END IF;

	INSERT INTO ts_typzdarzenia (tsz_nazwatypu, zd_rodzaj, tsz_oldid) VALUES(nazwa, 1, knt.rk_idrodzajkontaktu);
	
	ret = (SELECT currval('ts_typzdarzenia_s'));

	RETURN ret;
END;
$_$;
