CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _in       ALIAS FOR $1;
 _dodelete ALIAS FOR $2;
 ---------------
 iloscrest NUMERIC;
 inl       gm.DODAJ_WZ_TYPE;
 ret       gm.DODAJ_WZ_RETTYPE;
 retl      gm.DODAJ_WZ_RETTYPE;
 rec       RECORD;
 rez       gm.DODAJ_REZERWACJE_TYPE;
BEGIN

 _in._isteex=COALESCE(_in._isteex,0);

----RAISE NOTICE 'Mam tex %',_in;
 PERFORM gm.disableTouch(1);

 IF (_in.tex_idelem IS NOT NULL) THEN
  ret=gm.dodaj_wz_wtex(_in,_dodelete);
  PERFORM gm.disableTouch(-1);
  RETURN ret;
 END IF;

 inl=_in;
 ret.wartosc=0;
 iloscrest=_in.tel_iloscf;

 FOR rec IN SELECT * FROM tg_teex AS ex 
                     WHERE ex.tel_idelem=_in.tel_idelem 
		     ORDER BY ex.tex_idelem
 LOOP
  inl.tex_idelem=rec.tex_idelem;
  inl.tel_iloscf=rec.tex_iloscf;
  inl.prt_idpartii=rec.prt_idpartii;
  IF (_dodelete=TRUE) THEN
   inl.tel_iloscf=0;
  END IF;
  ---RAISE NOTICE 'Dodaj %',inl.tel_iloscf;
  iloscrest=iloscrest-inl.tel_iloscf;
  ---Wykonaj funkcje
  IF (rec.tex_flaga&(1<<3)=0) THEN
   ---RAISE NOTICE 'TEX2 %',inl;
   retl=gm.dodaj_wz_wtex(inl,_dodelete);
  END IF;
  ---Oblicz wartosc
  ret.wartosc=ret.wartosc+retl.wartosc;
 END LOOP;

 ----Nie znaleziono zadnego rekordu teex
 IF NOT FOUND THEN --BRAK teex
  IF (_in._isteex&3=0) THEN  -- Nie potrzeba teex - wyjdz
   ret=gm.dodaj_wz_wtex(_in,_dodelete);
   PERFORM gm.disableTouch(-1);
   RETURN ret;
  END IF;
  /*
  ELSE
   inl=_in;
   inl.tel_iloscf=0;
   inl.tex_idelem=NULL;
   inl._isteex=0;
   PERFORM gm.dodaj_wz_wtex(inl,TRUE);
  END IF;
  */
 ELSE
  ---Usun wszystkie nie-teex
  inl=_in;
  inl.tel_iloscf=0;
  inl.tex_idelem=NULL;
  inl._isteex=0;
  PERFORM gm.dodaj_wz_wtex(inl,TRUE);
 END IF;

 IF (_in._isteex&(3|16)=2) AND (iloscrest>=0) THEN
  --Uzyta funkcja rozpisania i jeszcze cos pozostalo
  --Daj w to miejsce rezerwacje
  rez.rc_ilosc=(SELECT sum(rc_ilosc) FROM tg_ruchy WHERE tel_idelem=_in.rez_idelem);
  rez.rc_ilosc=iloscrest;
  rez.prt_idpartii=_in.prt_idpartii;
  rez.tel_idelem_for=_in.tel_idelem;
  rez.tr_idtrans_for=_in.tr_idtrans;
  rez.k_idklienta_for=_in.tel_oidklienta;
  rez.data_rezerwacji='2079-11-29';
  rez.ttw_idtowaru=_in.ttw_idtowaru;
  rez.ttm_idtowmag=_in.ttm_idtowmag;
  rez.tmg_idmagazynu=_in.tmg_idmagazynu;
  rez._zewskazaniem=false;
  rez._idpzam=_in.rez_idelem;
  rez.ttw_whereparams=_in.ttw_whereparams;
  rez.ttw_inoutmethod=_in.ttw_inoutmethod;
  rez._rezerwacjalekka=true;
  PERFORM gm.dodaj_rezerwacje(rez,FALSE);
  iloscrest=0;
 END IF;

 PERFORM gm.disableTouch(-1);

 IF (iloscrest<>0) THEN
  RAISE EXCEPTION '44|%:%:%|Blad rozpisania na teex',_in.tel_idelem,_in.tel_iloscf,iloscrest;
 END IF;

 RETURN ret;
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 _ilosc ALIAS FOR $1;

 _idelem ALIAS FOR $2;
 _idtrans ALIAS FOR $3;
 _idtowaru ALIAS FOR $4;
 _idtowmag ALIAS FOR $5;
 _idmag ALIAS FOR $6;
 _idklienta ALIAS FOR $7;
 _data ALIAS FOR $8;
 _rez_idelem ALIAS FOR $9;       --- tel_skojlog
 _idodbiorcy ALIAS FOR $10;
 _pominrez   ALIAS FOR $11;
 _rez_idelem2 ALIAS FOR $12;
 _idpartii    ALIAS FOR $13;
 _teexmode    ALIAS FOR $14;

 _inv gm.DODAJ_WZ_TYPE;
 _ret gm.DODAJ_WZ_RETTYPE;
BEGIN
 _inv.tel_iloscf=_ilosc;
 _inv.tel_idelem=_idelem;
 _inv.tr_idtrans=_idtrans;
 _inv.ttw_idtowaru=_idtowaru;
 _inv.ttm_idtowmag=_idtowmag;
 _inv.tmg_idmagazynu=_idmag;
 _inv.k_idklienta=_idklienta;
 _inv.rc_data=_data;
 _inv._isteex=_teexmode;
 ----------------------
 _inv.rez_idelem=_rez_idelem;
 _inv.tel_oidklienta=_idodbiorcy;
 _inv._pominrez=_pominrez;
 _inv.rez_idelem2=_rez_idelem2;
 _inv.prt_idpartii=_idpartii;
 _ret=gm.dodaj_wz(_inv,FALSE);
 RETURN _ret.wartosc;
END;
$_$;
