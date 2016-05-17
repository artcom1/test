CREATE FUNCTION sync_apz(numeric, integer, integer, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _ilosc     ALIAS FOR $1;
 _idelem    ALIAS FOR $2;
 _idklienta ALIAS FOR $3;
 _idpartii  ALIAS FOR $4;
 r          gm.DODAJ_PZ_TYPE;
 ret        gm.DODAJ_PZ_RETTYPE;
BEGIN
 r.tel_iloscf=_ilosc;
 r.tel_idelem=_idelem;
 r.k_idklienta=_idklienta;
 r._isapz=TRUE;
 r.prt_idpartii=_idpartii;
 r.tel_wartosc=0;

 ret=gm.dodaj_pz(r,FALSE);

 return ret.wartosc;
END;
$_$;
