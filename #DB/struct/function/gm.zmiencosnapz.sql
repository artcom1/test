CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelem ALIAS FOR $1;
BEGIN

 UPDATE tg_transelem SET tel_newflaga=tel_newflaga|8,
               			 tel_kurswal=getKursDlaDokumentu(tr_idtrans,tel_walutawal) WHERE tel_idelem=_idelem;

 RETURN TRUE;
END
$_$;
