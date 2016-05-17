CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 id            INT;
 r             RECORD;
 iloscbo       NUMERIC;
 iloscrez      NUMERIC;
 hasrez        BOOL;
 --------------------------------
 rr   gm.DODAJ_REZERWACJE_TYPE;
BEGIN

 iloscbo=_ilosc;
 iloscrez=_iloscrez;
 IF (_zrezerwacja=TRUE) THEN
  iloscrez=iloscbo;
 END IF;
 iloscrez=max(0,min(iloscbo,iloscrez));

 IF (iloscrez IS NOT NULL AND NOT _isprzychod) THEN

  SELECT tm.ttw_idtowaru,tm.tmg_idmagazynu,tr.tr_oidklienta,tr.tr_datasprzedaz INTO r
   FROM tg_transakcje AS tr,tg_towmag AS tm 
   WHERE tr.tr_idtrans=_idtrans AND tm.ttm_idtowmag=_idtowmag;

  IF (_przeliczrez) THEN
   rr._rezdopzam=TRUE;
   rr.rc_ilosc=iloscrez;
   rr.tel_idelem_for=_idelemsrc;
   rr.tr_idtrans_for=_idtrans;
   rr.k_idklienta_for=r.tr_oidklienta;
   rr.data_rezerwacji=r.tr_datasprzedaz;
   rr.ttw_idtowaru=r.ttw_idtowaru;
   rr.ttm_idtowmag=_idtowmag;
   rr.tmg_idmagazynu=r.tmg_idmagazynu;
   rr._zewskazaniem=false;
   rr._idpzam=NULL;
   rr._rezid=(SELECT rc_seqid FROM tg_ruchy WHERE tel_idelem=_idelemsrc LIMIT 1);
   rr._onlywskazane=FALSE;
   rr.prt_idpartii=_idpartii;
   rr._idpzam=_idskojzam;
   rr._rezerwacjalekka=_rezlekka;
   PERFORM gm.dodaj_rezerwacje(rr);  
  END IF;

  iloscbo=max(iloscbo-nullZero((SELECT sum(rc_iloscrez) FROM tg_ruchy WHERE isRezerwacja(rc_flaga) AND tel_idelem=_idelemsrc)),0);
 END IF;

 id=(SELECT gm.dodajBackOrder(_idelemsrc,_idtowmag,iloscbo,_isprzychod,_powod,_zrezerwacja,_data,_zlecenie,_new2flaga));

 RETURN id;
END;
$$;
