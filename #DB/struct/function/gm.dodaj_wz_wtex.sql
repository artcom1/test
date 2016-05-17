CREATE FUNCTION dodaj_wz_wtex(dodaj_wz_type, boolean DEFAULT false) RETURNS dodaj_wz_rettype
    LANGUAGE plpgsql
    AS $_$
---WSPOK
DECLARE
 _in       ALIAS FOR $1;
 _dodelete ALIAS FOR $2;
 iloscpoz NUMERIC;

 t_iloscel NUMERIC;
 t_wartosc NUMERIC;

 t_ilosclrez NUMERIC:=0;

 ruch_data RECORD;
 ruch_data1 RECORD;

 stanmagrest NUMERIC;

 tmp NUMERIC:=0;
 tmp2 NUMERIC:=0;

 iloscbase NUMERIC;
 idrezerwacji INT;

 --FIFO
 q TEXT;
 q1 TEXT;

 ret gm.DODAJ_WZ_RETTYPE;
 pap tg_partie;

 iloscpominieta   NUMERIC:=0;
 ilosczr          NUMERIC;

BEGIN
 ---Wynik
 ret.wartosc=0;

 iloscpoz=_in.tel_iloscf;
 ---RAISE NOTICE 'Zmniejszam WZ % do % ',_in.tel_idelem,iloscpoz;
 PERFORM gm.disableTouch(1);

 IF (iloscpoz=0) THEN
  DELETE FROM tg_ruchy WHERE tel_idelem=_in.tel_idelem AND isFV(rc_flaga) AND tex_idelem IS NOT DISTINCT FROM _in.tex_idelem;
  PERFORM gm.disableTouch(-1);
  RETURN ret;
 END IF;


 IF (_in.ttw_whereparams IS NULL) OR (_in.ttw_inoutmethod IS NULL) THEN
  SELECT ttw_whereparams ,ttw_inoutmethod INTO ruch_data FROM tg_towary WHERE ttw_idtowaru=_in.ttw_idtowaru;
  _in.ttw_whereparams=ruch_data.ttw_whereparams;
  _in.ttw_inoutmethod=ruch_data.ttw_inoutmethod;
 END IF;

 IF (_in.prt_idpartii IS NULL) THEN
  _in.prt_idpartii=gm.getIDNULLPartii(_in.ttw_idtowaru,TRUE,-1);
 END IF;

 SELECT * INTO pap FROM tg_partie WHERE prt_idpartii=_in.prt_idpartii;
 PERFORM (SELECT ttm_idtowmag FROM tg_towmag WHERE ttm_idtowmag=_in.ttm_idtowmag FOR UPDATE);
 
 /* --------Sprawdz istniejace---------------------------------------------- */
 ---------------------------------------------------------------------------------------
 q='SELECT r.rc_ilosc,r.rc_iloscpoz,r.rc_wartosc,r.rc_cenajedn,r.rc_idruchu,r.k_idklienta,r.rc_iloscrezzr,
           sum(r.rc_iloscrezzr) OVER w AS sumilosczr,
           gm.isPartiaEqual(ppz,pr,'||gm.toString(_in.ttw_whereparams)||','||gm.toString(_in.prt_idpartii)||') AS isok,
	       r.rc_flaga,
		   r.rc_wspwartosci
    FROM tg_ruchy AS r 
    JOIN tg_ruchy AS pzr ON (r.rc_ruch=pzr.rc_idruchu)
    LEFT OUTER JOIN tg_partie AS pr ON (r.prt_idpartiiwz=pr.prt_idpartii)
    LEFT OUTER JOIN tg_partie AS ppz ON (pzr.prt_idpartiipz=ppz.prt_idpartii)
    LEFT OUTER JOIN gm.tv_oznaczoneruchy_top AS ozn ON (ozn.rc_idruchu=r.rc_idruchu) 
	'||gm.getinoutjoinclause(_in.ttw_inoutmethod,'pzr')||'
    WHERE r.tel_idelem='||_in.tel_idelem||' AND isFV(r.rc_flaga) 
          AND r.tex_idelem IS NOT DISTINCT FROM '||gm.toString(_in.tex_idelem)||' 
	WINDOW w AS ()	
    ORDER BY r.rc_idruchu ASC,(ozn.rc_idruchu IS NOT NULL) ASC,
    gm.comparePartie(ppz,'||vendo.record2string(pap)||'::tg_partie,'||_in.ttw_whereparams||') DESC,
    '||gm.getinoutsortclause(_in.ttw_inoutmethod,'pzr','ppz',FALSE);
 ---------------------------------------------------------------------------------------
 -- Zmniejszenie po ilosciach pozostalych
 FOR ruch_data IN EXECUTE q	 
 LOOP  
  iloscbase=iloscpoz;
  
  IF (ruch_data.isok = FALSE) THEN
   iloscbase=0;
  END IF;
  
  ---Obsluz ilosci oznaczone kolektorem - w sytuacji gdyby jako kolejny wystapil rekord
  ---Oznaczony kolektorem mogloby nie zostac ilosci do zmniejszenia
  IF (ilosczr IS NULL) THEN
   ilosczr=ruch_data.sumilosczr;
  END IF;
  ilosczr=ilosczr-ruch_data.rc_iloscrezzr;
  
  -- Ilosc ktora zostawic
  t_iloscel=round(max(max(ruch_data.rc_iloscrezzr,min(max(iloscbase-ilosczr,0),ruch_data.rc_ilosc)),0),4);
  
  IF (gm.isAnyOznaczonyRuchN()=TRUE AND gm.isOznaczonyRuchN(ruch_data.rc_idruchu)=FALSE) THEN
   IF (vendo.getconfigvalue('UsePartiaByWojtek')='1') THEN
    IF (ruch_data.rc_iloscrezzr>0) THEN
	 RAISE EXCEPTION 'Nie moge zmienic WPartii na ruchu juz potwierdzonym WMSMM';
	END IF;
    t_iloscel=max(0,ruch_data.rc_iloscrezzr);     --- Nie mniej niz ilosc potwierdzona
   ELSE
    t_iloscel=ruch_data.rc_iloscpoz;
   END IF;
  END IF;

  
  ---Pelny rozchod z partii
  IF (gm.isFullPartiaOnly(_in.ttw_whereparams,ruch_data.rc_idruchu)=TRUE) THEN
   IF (t_iloscel<>0) AND (_in.tel_iloscf<>ruch_data.rc_ilosc) THEN
    iloscpominieta=iloscpominieta+(ruch_data.rc_ilosc-iloscpoz);
    iloscpoz=iloscpoz-ruch_data.rc_ilosc;
    ret.wartosc=ret.wartosc+ruch_data.rc_wartosc;
    CONTINUE;
   END IF;
  END IF;

  -- Konieczna jest modyfikacja ilosci
  IF (t_iloscel<ruch_data.rc_iloscpoz) OR (_in.k_idklienta<>ruch_data.k_idklienta) THEN    
  
  
   IF (t_iloscel=0) THEN
    -- Zmiejszenie ilosci do 0
    DELETE FROM tg_ruchy WHERE rc_idruchu=ruch_data.rc_idruchu;
    tmp2=0;
   ELSE 
    IF (ruch_data.rc_ilosc<>t_iloscel) THEN
     tmp=round(ruch_data.rc_ilosc-t_iloscel,4);
     IF (t_iloscel=ruch_data.rc_ilosc) THEN
      tmp2=ruch_data.rc_wartosc*ruch_data.rc_wspwartosci;
     ELSE
      tmp2=floorRoundMax(ruch_data.rc_cenajedn*t_iloscel,ruch_data.rc_wartosc*ruch_data.rc_wspwartosci);
     END IF;
 
     -- Zmniejszenie ilosci
     UPDATE tg_ruchy SET rc_ilosc=round(t_iloscel,4),
                         rc_iloscpoz=round(round(rc_iloscpoz,4)-tmp,4),
                         rc_wartosc=tmp2*ruch_data.rc_wspwartosci,
                         rc_wartoscpoz=(tmp2-(rc_wartosc-rc_wartoscpoz)*ruch_data.rc_wspwartosci)*ruch_data.rc_wspwartosci,
                         k_idklienta=_in.k_idklienta 
                     WHERE rc_idruchu=ruch_data.rc_idruchu;
    ELSE
     tmp2=ruch_data.rc_wartosc*ruch_data.rc_wspwartosci;
    END IF;
   END IF;
  ELSE
   tmp2=ruch_data.rc_wartosc*ruch_data.rc_wspwartosci;
  END IF;

  iloscpoz=round(iloscpoz-t_iloscel,4);
  ret.wartosc=round(ret.wartosc+tmp2*ruch_data.rc_wspwartosci,6);
 END LOOP;
 

 /*
 ------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------
 */
 
 --- Szukaj rezerwacji, posortuj najpierw po rezerwacjach automatycznych, pozniej po recznych
 IF (iloscpoz>0) THEN
  q=gm.dodaj_wz_queryrez(_in,pap,TRUE);
---  RAISE NOTICE '%',gm.toNotice(q);
  FOR ruch_data IN EXECUTE q
  LOOP
    t_iloscel=round(max(min(iloscpoz,ruch_data.rc_iloscrez),0),4);
    ---RAISE NOTICE 'Cos znalazlem';

   IF (gm.isAnyOznaczonyRuchN()=TRUE AND gm.isOznaczonyRuchN(ruch_data.rc_idruchu)=FALSE) THEN
     t_iloscel=0;
    END IF;

    IF (ruch_data.rc_ruch IS NULL) THEN
     ret=gm.dodaj_wz_inner(_in,ret,pap,t_iloscel,t_iloscel,ruch_data.rc_idruchu,ruch_data.prt_idpartiipz);
     iloscpoz=round(iloscpoz-t_iloscel,6);
     CONTINUE;
    END IF;


    IF (t_iloscel>0) THEN
     --Zrealizuj na rzecz PZetek z tej rezerwacji
     --Pobierz cene jednostkowa z PZetu
     SELECT rc_cenajedn,rc_wartoscpoz,rc_iloscpoz,rc_wspwartosci INTO ruch_data1 FROM tg_ruchy WHERE rc_idruchu=ruch_data.rc_ruch;
 
     --- Jesli sciagamy wszystko to wszystko
     IF (t_iloscel=ruch_data1.rc_iloscpoz) THEN
      tmp=ruch_data1.rc_wartoscpoz*ruch_data1.rc_wspwartosci;
     ELSE
      tmp=floorRoundMax(ruch_data1.rc_cenajedn*t_iloscel,ruch_data1.rc_wartoscpoz*ruch_data1.rc_wspwartosci);                                    --- Wartosc ktora sciagamy
     END IF;

     --- Wstaw rekord z realizacja rezerwacji
     INSERT INTO tg_ruchy 
      (tel_idelem,tr_idtrans,ttw_idtowaru,k_idklienta,ttm_idtowmag,tmg_idmagazynu,rc_data,
       rc_ilosc,rc_iloscpoz,rc_flaga,
       rc_wartosc,rc_wartoscpoz,rc_cenajedn,
       rc_ruch,rc_rezerwacja,rc_iloscrez,rc_kierunek,rc_kierunekrez,
       prt_idpartiiwz,tex_idelem,
	   rc_wspwartosci
	   )
     VALUES
      (_in.tel_idelem,_in.tr_idtrans,_in.ttw_idtowaru,_in.k_idklienta,_in.ttm_idtowmag,_in.tmg_idmagazynu,_in.rc_data,
       round(t_iloscel,4),round(t_iloscel,4),8,
       tmp*ruch_data1.rc_wspwartosci,tmp*ruch_data1.rc_wspwartosci,ruch_data1.rc_cenajedn,
       ruch_data.rc_ruch,ruch_data.rc_idruchu,round(t_iloscel,4),-1,-1,
       _in.prt_idpartii,_in.tex_idelem,
	   ruch_data1.rc_wspwartosci
	   ); 

     iloscpoz=round(iloscpoz-t_iloscel,6);
     ret.wartosc=round(ret.wartosc+tmp,6);
    END IF;
   END LOOP;
  END IF;

  /*
  ------------------------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
  ------------------------------------------------------------------------------------------------------
  */
  --- Wez bezposrednio z PZetow
  IF (iloscpoz>0) THEN
   ret=gm.dodaj_wz_inner(_in,ret,pap,iloscpoz,0,NULL::int);
   iloscpoz=0;
  END IF;

  PERFORM gm.disableTouch(-1);

  IF (iloscpoz<0) THEN
   ---RAISE NOTICE 'Pominieto % ',iloscpominieta;
   IF (iloscpoz+iloscpominieta>=0) THEN
    RAISE EXCEPTION '45|%:%|Brakuje towaru do zmniejszenia!',_in.tel_idelem,-iloscpoz;
   END IF;
   RAISE EXCEPTION '32|%:%|Towar wydany juz przez MWS!',_in.tel_idelem,-iloscpoz;
  END IF;

 RETURN ret;
END; 
$_$;
