CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 _idelem   ALIAS FOR $1;
 _idtowmag ALIAS FOR $2;
 r   gm.DODAJ_REZERWACJE_TYPE;
 ret gm.DODAJ_REZERWACJE_RETTYPE;
BEGIN
 r.rc_ilosc=0;
 r.tel_idelem_for=_idelem;
 r.ttm_idtowmag=_idtowmag;
 r._onlywskazane=FALSE;
 ret=gm.dodaj_rezerwacje(r,TRUE);
 RETURN 1;
END;
$_$;
