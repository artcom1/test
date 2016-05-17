CREATE FUNCTION zmianailoscinapozycjizo(integer, numeric) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _tel_idelem   ALIAS FOR $1;
 deltailosci   ALIAS FOR $2;
-- poz           RECORD;
 _idpierwotny       INT;
BEGIN
-- SELECT * INTO poz FROM tg_transelem  WHERE tel_idelem=_tel_idelem;

 ---zmieniamy ilosc pierwotna o delte
 UPDATE tg_transelem SET 
        tel_ilosc=tel_ilosc-deltailosci,
	    tel_iloscop=gm.filterIloscOp(tel_iloscop-round(deltailosci*1000/tel_przelnopakow,4),tel_new2flaga),
	    tel_iloscf=tel_iloscf-round(deltailosci*1000/tel_przelnilosci,4),
	    tel_iloscdorezerwacji=min(tel_iloscdorezerwacji,tel_iloscf-round(deltailosci*1000/tel_przelnilosci,4)) 
 WHERE tel_idelem=_tel_idelem;

--- UPDATE tg_zamilosci SET zmi_if_pierw=zmi_if_pierw-round(poz.tel_przelnilosci*deltailosci/1000,4) WHERE tel_idelem=_tel_idelem;
 
 ---pobieramy element biezacy
 _idpierwotny=(SELECT tel_idelemsrc FROM tg_realizacjapzam WHERE tel_idpzam=_tel_idelem AND rm_powod=4);
 ---zmianiamy ilosc na elemencie biezacym
 IF (_idpierwotny>0) THEN
  UPDATE tg_transelem SET 
   tel_ilosc=tel_ilosc-deltailosci,
   tel_iloscop=gm.filterIloscOp(tel_iloscop-round(deltailosci*1000/tel_przelnopakow,4),tel_new2flaga),
   tel_iloscf=tel_iloscf-round(deltailosci*1000/tel_przelnilosci,4), 
   tel_iloscdorezerwacji=min(tel_iloscdorezerwacji,tel_iloscf-round(deltailosci*1000/tel_przelnilosci,4)) 
  WHERE tel_idelem=_idpierwotny;
   ---zmieniamy ilosc pierwotna na zamilosciach
  PERFORM gm.updateZamIlosci(_tel_idelem,FALSE);
 ELSE
  ---zmieniamy ilosc pierwotna na zamilosciach
  PERFORM gm.updateZamIlosci(_tel_idelem,TRUE);
 END IF;

 RETURN _idpierwotny;
END;
$_$;
