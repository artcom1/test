CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE 
 inv       gm.DODAJ_PZ_TYPE;
 ret       gm.DODAJ_PZ_RETTYPE;
BEGIN
 inv.tel_iloscf=_ilosc;
 inv.tel_idelem=_idelem;
 inv.tr_idtrans=_idtrans;
 inv.ttw_idtowaru=_idtowaru;
 inv.ttm_idtowmag=_idtowmag;
 inv.tmg_idmagazynu=_idmag;
 inv.k_idklienta=_idklienta;
 inv.rc_data=_data;
 inv.tel_wartosc=_wartosc;
 inv.tel_iloscrez=_iloscrez;
 inv._isapz=_isapz; 
 inv.prt_idpartii=_idpartii; 
 inv.rc_cenajmcrs=_cenajmcrs;
 
 ret=gm.dodaj_pz(inv,FALSE);
 return ret.wartosc;
END;
$$;
