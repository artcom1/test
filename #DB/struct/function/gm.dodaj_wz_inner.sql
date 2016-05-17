CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
--WSPOK
DECLARE
 _in          ALIAS FOR $1;    --- Parametry wejsciowe
 ret          ALIAS FOR $2;    --- Wynik
 pap          ALIAS FOR $3;
 iloscpoz     ALIAS FOR $4;    --- Ilosc do wydania
 t_ilosclrez  ALIAS FOR $5;    --- Ilosc rezerwacji lekkich do wykorzystania
 idrezerwacji ALIAS FOR $6;    --- ID rezerwacji do wykorzystania
 idpartiipz   ALIAS FOR $7;    --- ID partii PZ
 stanmagrest NUMERIC;          --- Ilosc niezarezerwowanego towaru na magazynie
 t_iloscel   NUMERIC;
 tmp         NUMERIC;
 ruch_data   RECORD;
 q           TEXT;
 iloscstart  NUMERIC:=iloscpoz;
BEGIN 

 ----RAISE WARNING 'W dodaj_wz_inner';

 IF (iloscpoz=0) THEN
  RETURN ret;
 END IF;

 q=gm.dodaj_wz_querypz(_in,pap,FALSE,idpartiipz);
 FOR ruch_data IN EXECUTE q
 LOOP
  EXIT WHEN (iloscpoz<=0);

  CONTINUE WHEN (idpartiipz IS NOT NULL) AND (ruch_data.prt_idpartiipz IS DISTINCT FROM idpartiipz);

  ---min(iloscpoz,ilosc_niezarezerwowana_na_pz)
  t_iloscel=round(max(min(iloscpoz,ruch_data.rc_zostalo),0),4);
---  RAISE NOTICE 'Iloscpoz % ilosclrez % biore %',iloscpoz,t_ilosclrez,t_iloscel;

  ---Wskazanie rezerwacji
  IF (gm.isAnyOznaczonyRuchN()=TRUE AND gm.isOznaczonyRuchN(ruch_data.rc_idruchu)=FALSE) THEN
   t_iloscel=0;
  END IF;

  CONTINUE WHEN t_iloscel<=0;

  ---Ilosc niezarezerwowana na partii
  stanmagrest=(SELECT ptm_stanmag-ptm_rezerwacje-ptm_rezerwacjel FROM tg_partietm WHERE ttm_idtowmag=_in.ttm_idtowmag AND prt_idpartii=ruch_data.prt_idpartiipz);

  ---Minimum (iloscel,ilosc_niezarezerwowan_na_partii+zezwolenie_na_zdjecie_z_partii)
  t_iloscel=min(t_iloscel,stanmagrest+t_ilosclrez);

-----  RAISE NOTICE 'Max % biore %',t_ilosclrez,t_iloscel;

  ---Pelny rozchod z partii
  IF (gm.isFullPartiaOnly(_in.ttw_whereparams,ruch_data.rc_idruchu)=TRUE) THEN
   IF (iloscstart<>ruch_data.rc_iloscpoz) THEN
    CONTINUE;
   END IF;
  END IF;


  CONTINUE WHEN (t_iloscel<=0);

  --- Jesli sciagamy wszystko to wszystko
  IF (t_iloscel=ruch_data.rc_iloscpoz) THEN
   tmp=ruch_data.rc_wartoscpoz*ruch_data.rc_wspwartosci;
  ELSE
   tmp=floorRoundMax(ruch_data.rc_cenajedn*t_iloscel,ruch_data.rc_wartoscpoz*ruch_data.rc_wspwartosci);                         --- Wartosc ktora sciagamy
  END IF;

  ---RAISE NOTICE 'Proboje dla ruchu pz % wziazc % (% % % %)',ruch_data.rc_idruchu,t_iloscel,ruch_data.rc_ilosc,ruch_data.rc_iloscpoz,ruch_data.rc_iloscrez,ruch_data.rc_iloscrezzr;

  INSERT INTO tg_ruchy 
   (tel_idelem,tr_idtrans,ttw_idtowaru,k_idklienta,ttm_idtowmag,tmg_idmagazynu,rc_data,
    rc_ilosc,rc_iloscpoz,rc_flaga,
    rc_wartosc,rc_wartoscpoz,rc_cenajedn,
    rc_ruch,rc_kierunek,rc_kierunekrez,
    prt_idpartiiwz,rc_rezerwacja,rc_iloscrez,
    tex_idelem,
	rc_wspwartosci
	)
   VALUES
   (_in.tel_idelem,_in.tr_idtrans,_in.ttw_idtowaru,_in.k_idklienta,_in.ttm_idtowmag,_in.tmg_idmagazynu,_in.rc_data,
    round(t_iloscel,4),round(t_iloscel,4),8,
    tmp*ruch_data.rc_wspwartosci,tmp*ruch_data.rc_wspwartosci,ruch_data.rc_cenajedn,
    ruch_data.rc_idruchu,-1,(CASE WHEN idrezerwacji IS NOT NULL THEN -1 ELSE 0 END),
    _in.prt_idpartii,idrezerwacji,t_iloscel,
    _in.tex_idelem,
	ruch_data.rc_wspwartosci
	); 

  ret.wartosc=round(ret.wartosc+tmp*ruch_data.rc_wspwartosci,6);
  iloscpoz=round(iloscpoz-t_iloscel,4);
 END LOOP;

 IF (iloscpoz>0) THEN
  RAISE EXCEPTION '1|%:%:%:%:%|Brak transakcji pierwotnej dla WZet',_in.ttw_idtowaru,_in.tmg_idmagazynu,_in.tel_idelem,iloscpoz,idrezerwacji;
 END IF;

 RETURN ret;
END;
$_$;
