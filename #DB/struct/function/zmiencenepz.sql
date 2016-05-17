CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelem ALIAS FOR $1;
 _cena ALIAS FOR $2;
 _waluta ALIAS FOR $3;
BEGIN

 UPDATE tg_transelem SET tel_newflaga=tel_newflaga|8,tel_cenawal=_cena,tel_walutawal=_waluta,tel_kurswal=getKursDlaDokumentu(tr_idtrans,_waluta) WHERE tel_idelem=_idelem;

 RETURN TRUE;
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelem ALIAS FOR $1;
 _cena ALIAS FOR $2;
 _cenab ALIAS FOR $3;
 _waluta ALIAS FOR $4;
BEGIN

 UPDATE tg_transelem SET tel_newflaga=tel_newflaga|8,
                         tel_cenawal=_cena,
			 tel_cenabwal=_cenab,
			 tel_walutawal=_waluta,
			 tel_kurswal=getKursDlaDokumentu(tr_idtrans,_waluta) WHERE tel_idelem=_idelem;

 RETURN TRUE;
END
$_$;
