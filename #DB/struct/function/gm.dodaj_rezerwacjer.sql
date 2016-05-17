CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtowaru  ALIAS FOR $1;
 _idtowmag  ALIAS FOR $2;
 _idmag     ALIAS FOR $3;
 _idklienta ALIAS FOR $4;
 _data      ALIAS FOR $5;
 _ilosc     ALIAS FOR $6;
 _idpartii  ALIAS FOR $7;
 _rezlekka  ALIAS FOR $8;
 r          gm.DODAJ_REZERWACJE_TYPE;
 ret        gm.DODAJ_REZERWACJE_RETTYPE;
BEGIN
 r.prt_idpartii=_idpartii;
 r.k_idklienta_for=_idklienta;
 r.data_rezerwacji=_data;
 r.ttw_idtowaru=_idtowaru;
 r.ttm_idtowmag=_idtowmag;
 r.tmg_idmagazynu=_idmag;
 r._zewskazaniem=FALSE;
 r._onlywskazane=FALSE;
 r._rezdopzam=FALSE;
 r.rc_ilosc=_ilosc;
 r._rezerwacjalekka=_rezlekka;
 ret=gm.dodaj_rezerwacje(r,FALSE);
 RETURN _ilosc;
END;
$_$;
