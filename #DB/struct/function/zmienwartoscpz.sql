CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelem ALIAS FOR $1;
 _wartosc ALIAS FOR $2;
 _waluta ALIAS FOR $3;
BEGIN

 UPDATE tg_transelem SET tel_newflaga=tel_newflaga|8,
			 tel_wnettowal=round(_wartosc,2),
			 tel_walutawal=_waluta,
			 tel_kurswal=getKursDlaDokumentu(tr_idtrans,_waluta) WHERE tel_idelem=_idelem;

 RETURN TRUE;
END
$_$;
