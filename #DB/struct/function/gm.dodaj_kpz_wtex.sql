CREATE FUNCTION dodaj_kpz_wtex(integer, numeric, integer, integer, integer, integer, integer, integer, date, integer, integer, numeric, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
---WSPOK
DECLARE 
 _idtex      ALIAS FOR $1;
 _ilosc      ALIAS FOR $2;   ---- ilosc korekty na minus (>=0)

 _idelem     ALIAS FOR $3;   --- ID tranelemu
 _idtrans    ALIAS FOR $4;   --- ID transakcji
 _idtowaru   ALIAS FOR $5;   --- ID towaru
 _idtowmag   ALIAS FOR $6;   --- ID towmag
 _idmag      ALIAS FOR $7;   --- ID magazynu
 _idklienta  ALIAS FOR $8;   --- ID klienta
 _data       ALIAS FOR $9;   --- Data sprzedazy
 _fvp        ALIAS FOR $10;  --- ID korygowanego tranelemu (PZetu) 
 _fvptex     ALIAS FOR $11;
 _wartosc    ALIAS FOR $12;  --- wartosc korekty na minus (>=0)
 _idpartii   ALIAS FOR $13;  --- ID partii


 iloscpoz NUMERIC;        --- Ilosc jeszcze pozostala do odjecia
 wartoscpoz NUMERIC;      --- Wartosc jeszcze pozostala do odjecia

 t_iloscel NUMERIC;       --- Wartosci tymczasowe
 t_wartosc NUMERIC;

 ruch_data RECORD;
 ruch_data1 RECORD;
 ruch_data2 RECORD;

 ret NUMERIC;

 faza_plusow INT:=0;

 _inv gm.DODAJ_WZ_TYPE;
 _ret gm.DODAJ_WZ_RETTYPE;
 
 wsp NUMERIC:=1;
BEGIN 

 wsp=(SELECT rc_wspwartosci FROM tg_ruchy WHERE tel_idelem=_fvp LIMIT 1); 
 RAISE NOTICE 'Mam KPZ % i %',_wartosc,wsp;
 _wartosc=_wartosc*wsp;

 -- Ilosc i wartosc korekty sa rowne 0 - nie rob nic (tzn usun ruchy)
 IF (_ilosc=0) AND (_wartosc=0) THEN
  PERFORM gm.clear_wz(_idelem);
  DELETE FROM tg_ruchy WHERE tel_idelem=_idelem AND (isKPZ(rc_flaga) OR isKWM(rc_flaga)) AND (tex_idelem IS NOT DISTINCT FROM _idtex);
  ---Upewnij sie ze zdjeto bit pozwolenia na rozna cene jednostkowa
  UPDATE tg_ruchy SET rc_idruchu=rc_idruchu WHERE isPZet(rc_flaga) AND tel_idelem=_idelem AND (tex_idelem IS NOT DISTINCT FROM _idtex);
  RETURN 0;
 END IF;

 iloscpoz=_ilosc;
 wartoscpoz=_wartosc;

 -- Zmniejszenie po ilosciach pozostalych
 FOR ruch_data IN 
  SELECT rc_idruchu,rc_ilosc,rc_wartosc,rc_ruch,rc_cenajedn,rc_wspmag,rc_wspwartosci
  FROM tg_ruchy 
  WHERE tel_idelem=_idelem AND ((isKPZ(rc_flaga) AND NOT isKPZP(rc_flaga)) OR isKWM(rc_flaga) OR isFV(rc_flaga)) AND
        (tex_idelem IS NOT DISTINCT FROM _idtex)
 LOOP
  t_iloscel=-ruch_data.rc_ilosc*ruch_data.rc_wspmag;
  t_wartosc=-ruch_data.rc_wartosc*ruch_data.rc_wspmag*ruch_data.rc_wspwartosci;
  
  IF (ruch_data.rc_wspwartosci!=wsp) THEN
   RAISE EXCEPTION 'Blad wspolczynnika wartosci (KPZ0)';
  END IF;
  
  iloscpoz=iloscpoz-t_iloscel;
  wartoscpoz=wartoscpoz-t_wartosc;
 END LOOP;

 IF (FOUND) AND (iloscpoz=0) AND (wartoscpoz=0) THEN
  RETURN round(_wartosc*wsp,6);
 END IF;

 IF (FOUND) AND ((iloscpoz<>0) OR (wartoscpoz<>0)) THEN


  IF (iloscpoz<>0) THEN
   RAISE EXCEPTION '33|%:%:%:%|Blad na korekcie PZ',_idtrans,_idelem,iloscpoz,wartoscpoz;
  END IF;

  iloscpoz=_ilosc;
  wartoscpoz=_wartosc;

  FOR ruch_data IN 
   SELECT rc_idruchu,rc_ilosc,rc_wartosc,rc_ruch,rc_cenajedn,rc_wspmag,rc_wspwartosci
   FROM tg_ruchy 
   WHERE tel_idelem=_idelem AND ((isKPZ(rc_flaga) AND NOT isKPZP(rc_flaga)) OR isFV(rc_flaga)) AND
        (tex_idelem IS NOT DISTINCT FROM _idtex)
  LOOP
   t_iloscel=-ruch_data.rc_ilosc*ruch_data.rc_wspmag;
   t_wartosc=-ruch_data.rc_wartosc*ruch_data.rc_wspmag*ruch_data.rc_wspwartosci;

   IF (ruch_data.rc_wspwartosci!=wsp) THEN
    RAISE EXCEPTION 'Blad wspolczynnika wartosci (KPZ1)';
   END IF;
   
   iloscpoz=iloscpoz-t_iloscel;
   wartoscpoz=wartoscpoz-t_wartosc;
  END LOOP;

  IF (FOUND) AND ((iloscpoz<>0) OR (wartoscpoz<>0)) THEN
   IF (iloscpoz<>0) THEN
    RAISE EXCEPTION '33|%:%:%:%|Blad na korekcie PZ',_idtrans,_idelem,iloscpoz,wartoscpoz;
   END IF;
  END IF;

 END IF;

 ---- Szukaj nowych rekordow :)
 LOOP
  --Skoncz po dwoch przebiegach lub gdy pozostalo 0
  EXIT WHEN (faza_plusow=2) OR (iloscpoz<=0);
  -- Zwieksz faze plusow
  faza_plusow=faza_plusow+1;

  FOR ruch_data1 IN SELECT * FROM (
                    SELECT rc.rc_idruchu,rc_wartoscpoz,rc_iloscpoz AS iloscorg,
                          rc_iloscpoz-(SELECT nullZero(sum(rc_iloscrez)) FROM tg_ruchy AS r WHERE r.rc_ruch=rc.rc_idruchu AND isRezerwacja(rc_flaga) AND tel_idelem<>_idelem) AS rc_iloscpoz,
                          rc_cenajedn,
						  rc_wspwartosci
                          FROM tg_ruchy AS rc 
                          LEFT OUTER JOIN gm.tv_oznaczoneruchy_top AS ozn ON (ozn.rc_idruchu=rc.rc_idruchu)
			              WHERE tel_idelem=_fvp AND isPZet(rc_flaga) AND rc_iloscpoz>0 AND
                               (tex_idelem IS NOT DISTINCT FROM _fvptex) AND
							   (
							    (gm.isAnyOznaczonyRuchN()=FALSE) OR (ozn.rc_idruchu IS NOT NULL)
							   )
			  ORDER BY rc.rc_idruchu ASC
	            ) AS a WHERE rc_iloscpoz>0
  LOOP
   --- Wstawiamy odpowiedni rekord, ktory:
   ---- a) ma odnosnik do PZetki
   ---- b) ilosc na nim jest dodatnia z tym ze wplyw na skojarzony tranelem jest ujemny
   ---- c) wartosc na nim jest dodatnia z tym ze wplyw na skojarzony tranelem jest ujemny
   ----RAISE NOTICE 'Znalazlem PZet z iloscia % i % i %',iloscpoz,ruch_data1.rc_iloscpoz,_ilosc;
   
   IF (ruch_data1.rc_wspwartosci!=wsp) THEN
    RAISE EXCEPTION  'Blad wspolczynnika wartosci (KPZ2)';
   END IF;

   t_iloscel=min(iloscpoz,ruch_data1.rc_iloscpoz);

   ---RAISE NOTICE 'Znalazlem % ',t_iloscel;

   SELECT rc_iloscpoz,rc_wartoscpoz,rc_idruchu,rc_wspwartosci INTO ruch_data2 
   FROM tg_ruchy AS rp 
   WHERE rp.rc_ruch=ruch_data1.rc_idruchu AND isKPZ(rc_flaga) AND isKPZP(rc_flaga) AND tr_idtrans=_idtrans;

   IF (COALESCE(ruch_data2.rc_wspwartosci,wsp) IS DISTINCT FROM wsp) THEN
    RAISE EXCEPTION  'Blad wspolczynnika wartosci (KPZ3) dla % (%!=%)',ruch_data2.rc_idruchu,ruch_data2.rc_wspwartosci,wsp;
   END IF;

   IF (faza_plusow=1) THEN
    --- Nie sciagaj wiecej niz plusowano przy pierwszym przebiegu
    t_iloscel=COALESCE(min(t_iloscel,nullZero(ruch_data2.rc_iloscpoz)),0);
   END IF;

   ---- Trzeba sciagnac tyle ile plusowano z wartoscia taka jak przed korekta
   IF (t_iloscel=ruch_data1.iloscorg-nullZero(ruch_data2.rc_iloscpoz)) THEN
    --Sciagamy tyle ile bylo przed korekta - sciagnij wiec calosc wartosci przed korekta :)
    t_wartosc=ruch_data1.rc_wartoscpoz*wsp-nullZero(ruch_data2.rc_wartoscpoz*wsp);
   ELSEIF (t_iloscel=ruch_data1.iloscorg) THEN
    --Sciagamy calosc ilosci - sciagnij calosc wartosci
    t_wartosc=ruch_data1.rc_wartoscpoz*wsp;
   ELSE
    --Sciagnij proporcjonalnie co ceny jednostkowej
    IF (faza_plusow=1) THEN
     t_wartosc=0;
     IF (ruch_data2.rc_idruchu IS NOT NULL) THEN
      t_wartosc=floorRoundMax(t_iloscel*nullZero(ruch_data2.rc_wartoscpoz*wsp)/ruch_data2.rc_iloscpoz,ruch_data2.rc_wartoscpoz*wsp);
      IF (t_iloscel=ruch_data2.rc_iloscpoz) THEN
       t_wartosc=floorRoundMax(wartoscpoz,ruch_data2.rc_wartoscpoz*wsp);
      END IF;
     END IF;
    ELSE 
     t_wartosc=floorRoundMax(t_iloscel*ruch_data1.rc_wartoscpoz*wsp/ruch_data1.iloscorg,ruch_data1.rc_wartoscpoz*wsp);
     IF (t_iloscel=iloscpoz) THEN
      t_wartosc=floorRoundMax(wartoscpoz,ruch_data1.rc_wartoscpoz*wsp);
     END IF;
    END IF;
   END IF;

   IF (iloscpoz>0) THEN
    INSERT INTO tg_ruchy 
     (tel_idelem,tr_idtrans,ttw_idtowaru,ttm_idtowmag,tmg_idmagazynu,rc_data,tex_idelem,
      rc_ilosc,rc_iloscpoz,rc_flaga,
      rc_wartosc,rc_wartoscpoz,rc_cenajedn,
      k_idklienta,rc_kierunek,rc_ruch,
	  rc_wspwartosci
	 ) 
    VALUES 
     (_idelem,_idtrans,_idtowaru,_idtowmag,_idmag,_data,_idtex,
      round(t_iloscel,4),round(t_iloscel,4),64,
      round(t_wartosc*wsp,6),round(t_wartosc*wsp,6),ruch_data1.rc_cenajedn,
      _idklienta,-1,ruch_data1.rc_idruchu,
	  wsp); 
 
      iloscpoz=iloscpoz-t_iloscel;
      wartoscpoz=wartoscpoz-t_wartosc;
      ---RAISE NOTICE 'Dodaje % % %',iloscpoz,t_iloscel,t_wartosc;
   END IF;

  END LOOP;
 END LOOP;
       
 IF (iloscpoz>0) THEN
  ---Teraz trzebaby znalezc inny rekord ruchu na ten towar
 _inv.tel_iloscf=iloscpoz;
 _inv.tel_idelem=_idelem;
 _inv.tr_idtrans=_idtrans;
 _inv.ttw_idtowaru=_idtowaru;
 _inv.ttm_idtowmag=_idtowmag;
 _inv.tmg_idmagazynu=_idmag;
 _inv.k_idklienta=_idklienta;
 _inv.rc_data=_data;
 _inv._isteex=0;
 _inv.tex_idelem=_idtex;
 _inv.prt_idpartii=gm.getIDPartiiWZForPZ(_idpartii,TRUE);
 ----------------------
 _inv._pominrez=TRUE;
 _ret=gm.dodaj_wz_wtex_safe(_inv,FALSE);
  wartoscpoz=wartoscpoz-_ret.wartosc*wsp;
  iloscpoz=0;
 END IF;

 IF (wartoscpoz<>0) THEN
  --Dodaj rekord PZetowy z oznaczeniem KWM
  ---RAISE NOTICE 'Dodaje KWM';
  DELETE FROM tg_ruchy WHERE tel_idelem=_idelem AND tex_idelem=_idtex AND isKWM(rc_flaga);
  INSERT INTO tg_ruchy 
   (tel_idelem,tr_idtrans,ttw_idtowaru,ttm_idtowmag,tmg_idmagazynu,tex_idelem,
    rc_data,rc_ilosc,rc_iloscpoz,rc_flaga,rc_wartosc,rc_wartoscpoz,k_idklienta,rc_kierunek,rc_wspmag,
	rc_wspwartosci) 
  VALUES 
   (_idelem,_idtrans,_idtowaru,_idtowmag,_idmag,_idtex,
    _data,0,0,65536,round(-wartoscpoz,6),round(-wartoscpoz,6),_idklienta,1,1,
	wsp); 
  wartoscpoz=0;
 ELSE
  DELETE FROM tg_ruchy WHERE tel_idelem=_idelem AND isKWM(rc_flaga) AND tex_idelem IS NOT DISTINCT FROM _idtex;
 END IF;

 ret=round(_wartosc*wsp,6);
 
 --- Zwracamy wartosc zakupu dla tego rekordu
 RETURN -ret;
END; $_$;
