CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
--WSPOK
DECLARE 
 _idtex     ALIAS FOR $1;
 _ilosc     ALIAS FOR $2;       --- Ilosc po korekcie

 _idelem    ALIAS FOR $3;      --- ID tranelemu
 _idtrans   ALIAS FOR $4;     --- ID transakcji
 _idtowaru  ALIAS FOR $5;    --- ID towaru
 _idtowmag  ALIAS FOR $6;    --- ID towmagu
 _idmag     ALIAS FOR $7;       --- ID magazynu
 _idklienta ALIAS FOR $8;   --- ID klienta
 _data      ALIAS FOR $9;        --- Data sprzedazy
 _fvp       ALIAS FOR $10;         --- Korygowany tranelem
 _fvptex    ALIAS FOR $11;         --- Korygowany tranelem
 _zamknieta ALIAS FOR $12;  --- Informacja o zamknieciu
 _wartosc   ALIAS FOR $13;    --- Wartosc po korekcie
 _idpartii  ALIAS FOR $14;    --- ID Partii (dla korekty do NE)

 iloscpoz NUMERIC:=0;       --- Ilosc pozostala  
 wartoscpoz NUMERIC;        --- Wartosc pozostala

 t_iloscel NUMERIC;         ---tmp

 t_wartosc NUMERIC;

 ruch_data RECORD;
 ruch_data1 RECORD;
 
 ret INT;
 wsp NUMERIC:=1;
BEGIN
 
 wsp=(SELECT rc_wspwartosci FROM tg_ruchy WHERE tel_idelem=_fvp LIMIT 1); 
 IF (wsp IS NULL) AND (_wartosc!=0) THEN
  ---KPZ do nieistniejacego dokumentu
  wsp=1;
 END IF;
 ----RAISE NOTICE 'Mam KPZPlus % i %',_wartosc,wsp;
 _wartosc=_wartosc*wsp;
 IF (COALESCE(_wartosc,0)=0 AND _ilosc=0) THEN
  wsp=COALESCE(wsp,0);
  _wartosc=0;
 END IF;

 iloscpoz=_ilosc;          --- Od tego bedziemy odejmowac
 wartoscpoz=_wartosc;      --- Od tego bedziemy odejmowac

 IF (_ilosc=0) OR (_zamknieta=0) THEN    --- Po korekcie zero - usun wszystkie rekordy          
  PERFORM gm.dodaj_pz_univ(0,_idelem,_idtrans,_idtowaru,_idtowmag,_idmag,_idklienta,_data,wartoscpoz*wsp,0,false,_idpartii,NULL);
  DELETE FROM tg_ruchy WHERE tel_idelem=_idelem AND tex_idelem IS NOT DISTINCT FROM _idtex;
  RETURN 0;
 END IF;

 IF (_fvp<0) THEN ---Korekta for NE
  PERFORM gm.dodaj_pz_univ(_ilosc,_idelem,_idtrans,_idtowaru,_idtowmag,_idmag,_idklienta,_data,_wartosc*wsp,0,false,_idpartii,NULL);
  RETURN _wartosc*wsp;
 END IF;

 FOR ruch_data IN 
  SELECT rc_ilosc,rc_wartosc,rc_wspwartosci
  FROM tg_ruchy AS kpz  
  WHERE kpz.tel_idelem=_idelem AND (isKPZP(kpz.rc_flaga) OR isPZet(rc_flaga)) AND
        kpz.tex_idelem IS NOT DISTINCT FROM _idtex
  ORDER BY kpz.rc_idruchu ASC
 LOOP
  t_iloscel=ruch_data.rc_ilosc;
  t_wartosc=ruch_data.rc_wartosc*ruch_data.rc_wspwartosci;
  
  IF (ruch_data.rc_wspwartosci!=wsp) THEN
   RAISE EXCEPTION 'Blad wspolczynnika wartosci';
  END IF;

  iloscpoz=iloscpoz-t_iloscel;
  wartoscpoz=wartoscpoz-t_wartosc;
 END LOOP;

 IF (FOUND) AND ((iloscpoz<>0) OR (wartoscpoz<>0)) THEN
  RAISE EXCEPTION '33|%:%:%:%|Blad na korekcie PZ',_idtrans,_idelem,iloscpoz,wartoscpoz;
 END IF;


 IF (iloscpoz>0) THEN

  --- Rozmnoz te ruchy gdzie juz cos sprzedano
  FOR ruch_data IN 
   SELECT r.rc_idruchu,r.rc_cenajedn,r.rc_ilosc,r.rc_iloscpoz,r.mm_idmiejsca 
   FROM tg_ruchy AS r 
   LEFT OUTER JOIN gm.tv_oznaczoneruchy_top AS ozn ON (ozn.rc_idruchu=r.rc_idruchu)
   WHERE r.ttm_idtowmag=_idtowmag AND isPZet(r.rc_flaga) AND r.tel_idelem=_fvp AND r.rc_iloscpoz<>r.rc_ilosc AND r.rc_iloscpoz>0 AND
         r.tex_idelem IS NOT DISTINCT FROM _fvptex AND							   
		(
 	     (gm.isAnyOznaczonyRuchN()=FALSE) OR (ozn.rc_idruchu IS NOT NULL)
   	    )
   ORDER BY r.rc_idruchu
  LOOP
   ---RAISE NOTICE 'Move % % %',ruch_data.rc_idruchu,ruch_data.mm_idmiejsca,ruch_data.rc_iloscpoz;
   PERFORM gm.movepz(ruch_data.rc_idruchu,ruch_data.mm_idmiejsca,ruch_data.rc_iloscpoz,TRUE);
  END LOOP;

  FOR ruch_data IN 
   SELECT r.rc_idruchu,r.rc_cenajedn,r.rc_ilosc,r.rc_iloscpoz,r.rc_wspwartosci
   FROM tg_ruchy AS r
   LEFT OUTER JOIN gm.tv_oznaczoneruchy_top AS ozn ON (ozn.rc_idruchu=r.rc_idruchu)
   WHERE r.ttm_idtowmag=_idtowmag AND isPZet(r.rc_flaga) AND r.tel_idelem=_fvp AND
         r.tex_idelem IS NOT DISTINCT FROM _fvptex AND
 		(
 	     (gm.isAnyOznaczonyRuchN()=FALSE) OR (ozn.rc_idruchu IS NOT NULL)
   	    )
   ORDER BY rc_idruchu
  LOOP
   t_iloscel=min(iloscpoz,ruch_data.rc_ilosc);
   
   IF (_wartosc=0) THEN
    wsp=ruch_data.rc_wspwartosci;
   END IF;

   IF (ruch_data.rc_wspwartosci!=wsp) THEN
    RAISE EXCEPTION 'Blad wspolczynnika wartosci';
   END IF;
     
   IF (t_iloscel=iloscpoz) THEN
    t_wartosc=wartoscpoz;
   ELSE
    t_wartosc=floorRoundMax(t_iloscel*_wartosc/_ilosc,wartoscpoz);
   END IF;

   IF (t_iloscel>0) THEN
    ----RAISE NOTICE 'Dodaje z plusem % %',t_wartosc,wsp;
    --- Dodaj jako korektaPZ (z plusem)
    INSERT INTO tg_ruchy 
     (tel_idelem,tr_idtrans,ttw_idtowaru,k_idklienta,ttm_idtowmag,tmg_idmagazynu,rc_data,tex_idelem,
      rc_ilosc,rc_iloscpoz,rc_flaga,
      rc_wartosc,rc_wartoscpoz,rc_cenajedn,
      rc_ruch,rc_kierunek,
	  rc_wspwartosci)
    VALUES
     (_idelem,_idtrans,_idtowaru,_idklienta,_idtowmag,_idmag,_data,_idtex,
      round(t_iloscel,4),round(t_iloscel,4),64+512,
      round(t_wartosc*wsp,6),round(t_wartosc*wsp,6),ruch_data.rc_cenajedn,
      ruch_data.rc_idruchu,1,
	  wsp);  

	  
	IF (gm.isAnyOznaczonyRuchN()=TRUE) THEN
     ret=currval('tg_ruchy_s');	  	 
	 PERFORM gm.oznaczRuchN(gm.topOznaczRuchN(),ret,TRUE);
    END IF;
	  
   END IF;
   iloscpoz=round(iloscpoz-t_iloscel,4);
   wartoscpoz=round(wartoscpoz-t_wartosc,6);
   ---Przepisz tam jeszcze stara cene jednostkowa zeby rekord ujemny mogl zdjac poprawna srednia
   IF (ruch_data.rc_ilosc=ruch_data.rc_iloscpoz) THEN
    UPDATE tg_ruchy SET rc_cenajedn=ruch_data.rc_cenajedn,
                        rc_flaga=rc_flaga|131072 
    WHERE rc_idruchu=ruch_data.rc_idruchu;
   END IF;
  END LOOP;
 END IF;

 IF (wartoscpoz=0) THEN
  DELETE FROM tg_ruchy WHERE tel_idelem=_idelem AND isKWM(rc_flaga) AND tex_idelem IS NOT DISTINCT FROM _idtex;
 ELSE
  IF (iloscpoz=0) THEN
   SELECT rc_idruchu INTO ruch_data1 FROM tg_ruchy WHERE tel_idelem=_idelem AND isKWM(rc_flaga) AND tex_idelem IS NOT DISTINCT FROM _idtex;
   IF NOT FOUND THEN
   
    INSERT INTO tg_ruchy 
     (tel_idelem,tr_idtrans,ttw_idtowaru,ttm_idtowmag,tmg_idmagazynu,tex_idelem,
      rc_data,rc_ilosc,rc_iloscpoz,rc_flaga,rc_wartosc,rc_wartoscpoz,k_idklienta,rc_kierunek,rc_wspmag,
	  rc_wspwartosci) 
    VALUES 
     (_idelem,_idtrans,_idtowaru,_idtowmag,_idmag,_idtex,
      _data,0,0,65536,round(wartoscpoz*wsp,6),round(wartoscpoz*wsp,6),_idklienta,1,1,
	  wsp); 
	
   ELSE
    UPDATE tg_ruchy SET rc_wartosc=round(wartoscpoz*wsp,6),rc_wartoscpoz=round(wartoscpoz*wsp,6),rc_wspwartosci=wsp WHERE rc_idruchu=ruch_data1.rc_idruchu;
   END IF;
   wartoscpoz=0;
  END IF;
 END IF;

 IF (iloscpoz<>0) THEN
  IF (_idtex IS NOT NULL) THEN RAISE NOTICE 'Blad KPZ tex'; END IF;
  
  PERFORM gm.dodaj_pz_univ(iloscpoz,_idelem,_idtrans,_idtowaru,_idtowmag,_idmag,_idklienta,_data,wartoscpoz*wsp,0,false,_idpartii,NULL);
  
  IF (gm.isAnyOznaczonyRuchN()=TRUE) THEN
   PERFORM gm.oznaczRuchN(gm.topOznaczRuchN(),rc_idruchu,TRUE) FROM tg_ruchy WHERE isPZet(rc_flaga) AND tel_idelem=_idelem;
  END IF;  
 END IF;

 RETURN _wartosc*wsp;
END; 
$_$;
