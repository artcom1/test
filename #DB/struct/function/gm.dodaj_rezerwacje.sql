CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 _in        ALIAS FOR $1;
 _dodelete  ALIAS FOR $2;

 _rp        tg_partie;

 iloscpoz   NUMERIC;

 t_iloscel  NUMERIC;
 t_iloscst  NUMERIC;
 flaga      INT:=0;

 ruch_data  RECORD;
 zdjeto     NUMERIC;

 --FIFO
 method     INT;
 q          TEXT;

 cr         gm.SKOPIUJ_REZERWACJE_TYPE;
 crd        gm.DODAJ_REZERWACJE_TYPE;
 kr         gm.KONWERSJAREZERWACJAPZAM_TYPE;
 ------------------------------------------------
 ret        gm.DODAJ_REZERWACJE_RETTYPE;
 tmp        NUMERIC;
 robpetle   BOOL:=TRUE;
 idpartiipz INT;
 rezlekka   NUMERIC:=0;
 pozostalozajete   NUMERIC;
 pozostalooczekuje NUMERIC;
BEGIN
 ---RAISE EXCEPTION 'Rezerwacja lekka %',_in._rezerwacjalekka;
 _in._rezerwacjalekka=COALESCE(_in._rezerwacjalekka,FALSE);
 _in._onlywskazane=COALESCE(_in._onlywskazane,FALSE);
 _in._nonewrezerwacja=COALESCE(_in._nonewrezerwacja,FALSE);
 
 IF (_in._rezerwacjalekka=TRUE) THEN
  IF (gm.isAnyOznaczonyRuchN()=TRUE) THEN
   _in._rezerwacjalekka=FALSE;
  END IF;
 END IF;


 ret.rezid=_in._rezid;

 IF (ret.rezid IS NULL) THEN
  ret.rezid=nextval('tg_ruchy_seqid');
 END IF;

 IF (_in.ttw_idtowaru IS NULL) THEN
  SELECT ttw_idtowaru,tmg_idmagazynu INTO ruch_data FROM tg_towmag WHERE ttm_idtowmag=_in.ttm_idtowmag FOR UPDATE;
  _in.ttw_idtowaru=ruch_data.ttw_idtowaru;
  _in.tmg_idmagazynu=ruch_data.tmg_idmagazynu;
 END IF;

 IF (_in.prt_idpartii IS NULL) /*OR (_in._rezerwacjalekka=TRUE)*/ THEN
  _in.prt_idpartii=gm.getIDNULLPartii(_in.ttw_idtowaru,TRUE,-1);
 END IF;

 IF (_in.ttw_whereparams IS NULL) OR (_in.ttw_inoutmethod IS NULL) THEN
  _in.ttw_whereparams=(SELECT ttw_whereparams FROM tg_towary WHERE ttw_idtowaru=_in.ttw_idtowaru);
  _in.ttw_inoutmethod=(SELECT ttw_inoutmethod FROM tg_towary WHERE ttw_idtowaru=_in.ttw_idtowaru);
 END IF;

 IF (_dodelete=FALSE) THEN
  kr.rc_ilosc=_in.rc_ilosc;
  kr.tel_idelem_fv=_in.tel_idelem_for;
  kr.tel_idelem_pzam=_in._idpzam;
  kr.tr_idtrans_fv=_in.tr_idtrans_for;
  kr.ttm_idtowmag=_in.ttm_idtowmag;
  kr.prt_idpartii=_in.prt_idpartii;
  kr.ttw_inoutmethod=_in.ttw_inoutmethod;
  kr.ttw_whereparams=_in.ttw_whereparams;
  ---RAISE NOTICE 'KR %',kr;
  PERFORM gm.konwersjarezerwacjapzam(kr);
 END IF;

 IF (_in.rc_ilosc<0) AND (_in.tel_idelem_for IS NOT NULL) THEN
  --- Zrob tak by wszystkie rezerwacje mialy wielkosc do wielkosci zrealizowanej przez FV
  --- Dla reczno - automatycznych mozna zrobic tak by w tym przypadku sam sobie kopiowal nadmiar
  UPDATE tg_ruchy SET rc_ilosc=rc_iloscrezzr WHERE tel_idelem=_in.tel_idelem_for AND isRezerwacja(rc_flaga) AND rc_ilosc!=rc_iloscrezzr;
  RETURN ret;
 END IF;

 ---RAISE NOTICE 'dodaj_rezerwacje dla % na % ',_in.tel_idelem_for,_in.rc_ilosc;


 -------Pobierz partie
 SELECT * INTO _rp FROM tg_partie WHERE prt_idpartii=_in.prt_idpartii;

 ---Ilosc do zarezerwowania
 iloscpoz=_in.rc_ilosc;

 IF (_in.tel_idelem_for IS NOT NULL) THEN
  flaga=256|512;
 END IF;

 IF (_in._rezdopzam=TRUE) THEN
  flaga=flaga|(1<<19);
 END IF;

 --------Sprawdz istniejace---------------------------------------------- 
 t_iloscst=0;

 ---RAISE NOTICE 'Dla % ',_in.tel_idelem_for;

 WHILE (robpetle=TRUE) AND (COALESCE(_in.k_idklienta_for,0)>=0)
 LOOP
  robpetle=FALSE;

---  RAISE NOTICE 'Wchodze w petlle % ',_in.tel_idelem_for;

  -- Zmniejszenie po ilosciach pozostalych bardzo bezpieczne dla PZetek
  q='WITH pneww AS (SELECT * FROM tg_partie WHERE prt_idpartii='||_in.prt_idpartii||')
     SELECT r.rc_flaga,r.rc_ilosc,r.rc_iloscrezzr,r.rc_ilosc-r.rc_iloscrezzr AS rc_oczekuje,r.rc_idruchu,r.k_idklienta,
            r.prt_idpartiiwz,r.rc_ruch,
	    r.rc_iloscrez,
	    sum(r.rc_ilosc-r.rc_iloscrezzr) OVER w AS ileoczekuje,
	    sum(r.rc_iloscrez) OVER w AS ilezajete,
	    gm.isPartiaWZEqual(pold,pnew,'||_in.ttw_whereparams||') AS isok
     FROM tg_ruchy AS r
     LEFT OUTER JOIN tg_ruchy AS rpz ON (rpz.rc_idruchu=r.rc_ruch)
     LEFT OUTER JOIN tg_partie AS ppz ON (ppz.prt_idpartii=rpz.prt_idpartiipz) 
     LEFT OUTER JOIN tg_partie AS pold ON (r.prt_idpartiiwz=pold.prt_idpartii) '||gm.getinoutjoinclause(_in.ttw_inoutmethod,'rpz')||'
     LEFT OUTER JOIN pneww AS pnew ON (TRUE)
     WHERE r.tel_idelem='||gm.toString(_in.tel_idelem_for)||' AND isRezerwacja(r.rc_flaga) AND 
     r.ttm_idtowmag='||_in.ttm_idtowmag||' AND 
     (NOT '||gm.toString(_in._onlywskazane)||' OR r.rc_seqid='||gm.toString(ret.rezid)||')
     WINDOW w AS ()
     ORDER BY r.rc_ruch is NOT NULL ASC,'||gm.getinoutsortclause(_in.ttw_inoutmethod,'rpz','ppz',FALSE);
  ---RAISE NOTICE '%',gm.toNotice(q);
  FOR ruch_data IN EXECUTE q
  LOOP
   ---Powinno pozostac minimum z iloscipoz i ilosci na biezacym rekordzie
   t_iloscel=min(iloscpoz,ruch_data.rc_oczekuje);

   ---RAISE NOTICE 'Znalazlem % ',t_iloscel;

   IF (pozostalozajete IS NULL) THEN
    pozostalozajete=ruch_data.ilezajete;
    pozostalooczekuje=ruch_data.ileoczekuje;
   END IF;
   pozostalozajete=pozostalozajete-ruch_data.rc_iloscrez;
   pozostalooczekuje=pozostalooczekuje-ruch_data.rc_oczekuje;

   ----RAISE NOTICE 'Dla % oczekuje % pzajete % iloscpoz % poczekuje % (ilosc %) t_iloscel %',ruch_data.rc_idruchu,ruch_data.rc_oczekuje,pozostalozajete,iloscpoz,pozostalooczekuje,_in.rc_ilosc,t_iloscel;
   
   tmp=pozostalozajete-(iloscpoz-t_iloscel);
   IF (tmp>0) THEN
    t_iloscel=max(0,t_iloscel-tmp);
   END IF;
 
   IF (ruch_data.prt_idpartiiwz<>_in.prt_idpartii) AND (ruch_data.isok=false) THEN
    ---RAISE NOTICE 'Zmniejszam do zera';
    t_iloscel=0;
   END IF;

   ---Pelny rozchod z partii
   IF (gm.isFullPartiaOnly(_in.ttw_whereparams,ruch_data.rc_idruchu)=TRUE) AND (t_iloscel<>0) THEN
    iloscpoz=iloscpoz-ruch_data.rc_oczekuje;
    CONTINUE;
   END IF;


/*
   IF (_in._rezerwacjalekka<>isRezerwacjaLekka(ruch_data.rc_flaga)) THEN
    t_iloscel=0;
   END IF;
*/


--   RAISE NOTICE 'Mam iloscpoz % a oczekuje % (ID %) % (% %) %',iloscpoz,ruch_data.rc_oczekuje,ruch_data.rc_idruchu,t_iloscel,ruch_data.prt_idpartiiwz,_in.prt_idpartii,ruch_data.rc_ilosc;

   IF (t_iloscel<ruch_data.rc_oczekuje) OR (ruch_data.k_idklienta<>_in.k_idklienta_for) THEN
    tmp=ruch_data.rc_ilosc-(ruch_data.rc_iloscrezzr+t_iloscel);
    --RAISE NOTICE 'Poprezstack z tmp % ',tmp;
    IF (tmp>0) THEN
     PERFORM gm.popRezStack(ruch_data.rc_idruchu,tmp);
     IF (ruch_data.rc_ruch IS NOT NULL) OR (ruch_data.rc_iloscrez>0) THEN
      robpetle=TRUE;
      iloscpoz=_in.rc_ilosc;
	  
---      RAISE NOTICE 'Jeszcze jedna petla % (% %) %',ruch_data.rc_ruch,ruch_data.k_idklienta,_in.k_idklienta_for,tmp;
      EXIT;
     END IF;
    END IF;
   END IF;
   iloscpoz=iloscpoz-t_iloscel;
  END LOOP;

 END LOOP;


 _in.k_idklienta_for=abs(_in.k_idklienta_for);
  
 -----------------------------------------------------------------------------------------------------------------------------
 --- Wykorzystanie istniejacych rezerwacji recznych (tylko wtedy jesli nie wprowadzamy rezerwacji recznych :) !
 ----------OK dla rezerwacji lekkich (bo lekkie przekonwertuje na lekkie,ciezkie dla ciezkie)
 ----------Choc powinno byc tak ze potrafi zrobic z lekkiej ciezka
 IF (iloscpoz>0) AND (_in.tel_idelem_for IS NOT NULL) THEN
  q='SELECT r.*,rpz.rc_iloscpoz AS iloscpoz,rpz.rc_idruchu AS rc_idruchupz
     FROM tg_ruchy AS r
     JOIN tg_ruchy AS rpz ON (rpz.rc_idruchu=r.rc_ruch)
     JOIN tg_partie AS ppz ON (ppz.prt_idpartii=rpz.prt_idpartiipz) 
 	 LEFT OUTER JOIN gm.tv_oznaczoneruchy_top AS ozn ON (ozn.rc_idruchu=r.rc_idruchu) '||gm.getinoutjoinclause(_in.ttw_inoutmethod,'rpz')||'
     WHERE r.ttm_idtowmag='||_in.ttm_idtowmag||' AND 
           r.tel_idelem=NULL AND r.k_idklienta='||_in.k_idklienta_for||' AND 
	   isRezerwacja(r.rc_flaga) AND r.rc_iloscrez>0 AND 
---           ('||gm.toString(_in._rezerwacjalekka)||'=isRezerwacjaLekka(r.rc_flaga)) AND
	   (NOT '||gm.toString(_in._zewskazaniem)||' OR ozn.rc_idruchu IS NOT NULL)
	   '||gm.getWhereClause('ppz',_rp,_in.ttw_whereparams)||'
           ORDER BY '||gm.getinoutsortclause(_in.ttw_inoutmethod,'rpz','ppz',FALSE)||',r.rc_seqid';
  FOR ruch_data IN EXECUTE q
  LOOP    
   --- Potrzeba nam zarezerwowac tylko tyle ile zostalo
   ---TODO: Odlozyc na stos informacje o rezerwacji recznej
   t_iloscel=min(iloscpoz,ruch_data.rc_iloscrez); ---Wersja z przenoszeniem tylko tego co bylo dostepne

   ---Pelny rozchod z partii
   IF (gm.isFullPartiaOnly(_in.ttw_whereparams,ruch_data.rc_idruchupz)=TRUE) THEN
    IF (_in.rc_ilosc<>ruch_data.iloscpoz) THEN
     CONTINUE;
    END IF;
   END IF;

/*
   IF (NEW.rc_ruch IS NULL) THEN
    RAISE EXCEPTION 'TODO';
   END IF;
   */

   cr=NULL;
   cr.rc_idruchu_src=ruch_data.rc_idruchu;
   cr.tel_idelem_dst=_in.tel_idelem_for;
   cr.tex_idelem_dst=_in.tex_idelem_for;
   cr.tr_idtrans_dst=_in.tr_idtrans_for;
   cr.rc_ilosctocopy=t_iloscel;
   cr.rc_addflaga=(1<<19);
   PERFORM gm.skopiujRezerwacje(cr);
   iloscpoz=iloscpoz-t_iloscel;
  END LOOP;

 END IF;

 -----------------------------------------------------------------------------------------------------------------------------
 ---- Dodanie rezerwacji lekkiej
 ----------OK dla rezerwacji lekkich 
 IF (_in._rezerwacjalekka=TRUE) AND (iloscpoz>0) AND (_in._nonewrezerwacja=FALSE) THEN
----  RAISE EXCEPTION 'COs zostalo %',iloscpoz;
  crd=_in;
  crd.rc_ilosc=iloscpoz;
  PERFORM gm.dodaj_rezerwacje_lekka(crd,_rp);
  RETURN ret;
 END IF;


 -----------------------------------------------------------------------------------------------------------------------------
 ---- Dodanie nowej rezerwacji do istniejacego PZeta
 ----------OK dla rezerwacji lekkich (bo dla lekkich nie dojdzie, dla ciezkich sa uwzglednione rezerwacje)
 IF (iloscpoz>0) AND (_in._nonewrezerwacja=FALSE) THEN
  --Tyle mozemy wykorzystac stanu magazynowego
  q='SELECT r.rc_iloscpoz,r.rc_iloscrez,r.rc_iloscrezzr,r.rc_idruchu,r.rc_flaga,r.prt_idpartiipz
      FROM tg_ruchy AS r
      JOIN tg_partie AS ppz ON (ppz.prt_idpartii=r.prt_idpartiipz) 
  	  LEFT OUTER JOIN gm.tv_oznaczoneruchy_top AS ozn ON (ozn.rc_idruchu=r.rc_idruchu) '||gm.getinoutjoinclause(_in.ttw_inoutmethod,'r')||'
      WHERE ttm_idtowmag='||_in.ttm_idtowmag||'
      AND isPZet(r.rc_flaga) AND NOT isBlockedPZ(r.rc_flaga) 
      AND r.rc_iloscpoz-(r.rc_iloscrez-r.rc_iloscrezzr)>0 
      AND r.rc_iloscpoz>0
	  AND ('||gm.toString(_in.rc_idruchupz)||' IS NULL OR '||gm.toString(_in.rc_idruchupz)||'=r.rc_idruchu)
      AND (NOT '||(CASE WHEN _in._onlywskazane=TRUE THEN 'TRUE' ELSE 'FALSE' END)||' OR ozn.rc_idruchu IS NOT NULL) 
      '||gm.getWhereClause('ppz',_rp,_in.ttw_whereparams)||'
      ORDER BY (ozn.rc_idruchu IS NOT NULL) DESC,'||gm.getinoutsortclause(_in.ttw_inoutmethod,'r','ppz',FALSE);
  FOR ruch_data IN EXECUTE q
  LOOP
   t_iloscel=ruch_data.rc_iloscpoz-(ruch_data.rc_iloscrez-ruch_data.rc_iloscrezzr);
   t_iloscel=min(iloscpoz,t_iloscel);

   CONTINUE WHEN t_iloscel<=0;

   ---Rezerwacje lekkie
   rezlekka=(SELECT ptm_stanmag-ptm_rezerwacje-ptm_rezerwacjel FROM tg_partietm WHERE ttm_idtowmag=_in.ttm_idtowmag AND prt_idpartii=ruch_data.prt_idpartiipz FOR UPDATE);

   t_iloscel=min(t_iloscel,rezlekka);

   ---Pelny rozchod z partii
   IF (gm.isFullPartiaOnly(_in.ttw_whereparams,ruch_data.rc_idruchu)=TRUE) THEN
    IF (_in.rc_ilosc<>ruch_data.rc_iloscpoz) THEN
     CONTINUE;
    END IF;
   END IF;

   CONTINUE WHEN t_iloscel<=0;

   IF (gm.isAnyOznaczonyRuchN()=TRUE AND gm.isOznaczonyRuchN(ruch_data.rc_idruchu)=FALSE) THEN
    CONTINUE;
   END IF;


   ---RAISE EXCEPTION 'Dodaje rekord rezerwacyjny (M1)';
   INSERT INTO tg_ruchy 
    (tel_idelem,tr_idtrans,ttw_idtowaru,ttm_idtowmag,tmg_idmagazynu,rc_data,
     rc_ilosc,rc_iloscpoz,rc_flaga,k_idklienta,rc_ruch,rc_seqid,prt_idpartiiwz)
   VALUES
    (_in.tel_idelem_for,_in.tr_idtrans_for,_in.ttw_idtowaru,_in.ttm_idtowmag,_in.tmg_idmagazynu,_in.data_rezerwacji,
     round(t_iloscel,4),round(t_iloscel,4),1|flaga,abs(_in.k_idklienta_for),ruch_data.rc_idruchu,ret.rezid,_in.prt_idpartii); 

   IF (gm.isOznaczonyRuchN(ruch_data.rc_idruchu)=TRUE) THEN
    PERFORM gm.copyOznaczenia(ruch_data.rc_idruchu,currval('tg_ruchy_s')::int);
   END IF;

   iloscpoz=round(iloscpoz-t_iloscel,4);
   rezlekka=rezlekka-t_iloscel;
  END LOOP;

 END IF;

 -----------------------------------------------------------------------------------------------------------------------------
 ----------OK dla rezerwacji ciezkich (bo dla lekkich nie dojdzie, dla ciezkich nie dobiera PZeta)
 IF (iloscpoz>0) AND (_in.tel_idelem_for IS NOT NULL) AND (_in._nonewrezerwacja=FALSE) THEN
  q='SELECT r.* 
     FROM tg_ruchy AS r 
     LEFT OUTER JOIN tg_partie AS p ON (r.prt_idpartiiwz=p.prt_idpartii)
     LEFT OUTER JOIN tg_partie AS ip ON (ip.prt_idpartii='||gm.toString(_in.prt_idpartii)||')
 	 LEFT OUTER JOIN gm.tv_oznaczoneruchy_top AS ozn ON (ozn.rc_idruchu=r.rc_idruchu)
     WHERE r.ttm_idtowmag='||_in.ttm_idtowmag||' AND 
           r.tel_idelem=NULL AND r.k_idklienta='||_in.k_idklienta_for||' AND 
	   isRezerwacja(r.rc_flaga) AND r.rc_ilosc-r.rc_iloscrezzr>0 AND 
	   (NOT '||(CASE WHEN _in._zewskazaniem=TRUE THEN 'TRUE' ELSE 'FALSE' END)||' OR ozn.rc_idruchu IS NOT NULL) AND 
	   (NOT '||(CASE WHEN _in._onlywskazane=TRUE THEN 'TRUE' ELSE 'FALSE' END)||' OR ozn.rc_idruchu IS NOT NULL) AND
	   (r.rc_ruch IS NOT NULL OR NOT isRezerwacjaLekka(r.rc_flaga)) AND
	   gm.isPartiaWZEqual(p,ip,'||_in.ttw_whereparams||')
     ORDER BY r.rc_idruchu';
  ---RAISE NOTICE '%',gm.toNotice(q);
  FOR ruch_data IN EXECUTE q
  LOOP    
   ---RAISE NOTICE 'Biore z rezerwacji o ID % ',ruch_data.rc_idruchu;
   --- Potrzeba nam zarezerwowac tylko tyle ile zostalo
   t_iloscel=min(iloscpoz,ruch_data.rc_ilosc-ruch_data.rc_iloscrezzr); 
   cr=NULL;
   cr.rc_idruchu_src=ruch_data.rc_idruchu;
   cr.tel_idelem_dst=_in.tel_idelem_for;
   cr.tex_idelem_dst=_in.tex_idelem_for;
   cr.tr_idtrans_dst=_in.tr_idtrans_for;
   cr.rc_ilosctocopy=t_iloscel;
   cr.rc_addflaga=flaga&(1<<19);
   PERFORM gm.skopiujRezerwacje(cr);
   iloscpoz=iloscpoz-t_iloscel;
  END LOOP;

 END IF;

 ---Tutaj juz generalnie sa rezerwacje w przyszlosc :)
 IF (iloscpoz>0) AND (gm.isAnyOznaczonyRuchN()=TRUE) AND (_in._nonewrezerwacja=FALSE) THEN
  ---IF (_in.tel_idelem_for IS DISTINCT FROM 114262) THEN
   RAISE EXCEPTION '46|%:%:%:%|Rezerwacja poza wskazana partia',_in.ttw_idtowaru,_in.tmg_idmagazynu,_in.tel_idelem_for,iloscpoz;
  ---END IF;
 END IF;

 -----------------------------------------------------------------------------------------------------------------------------
 ----------OK dla rezerwacji ciezkich (bo dla lekkich nie dojdzie, dla ciezkich nie dobiera PZeta)
 IF (iloscpoz>0) AND (_in._onlywskazane=FALSE) AND (_in._nonewrezerwacja=FALSE) THEN
  ---RAISE NOTICE 'Dodaje rezerwacje w przyszlosc % (M2) total % (tel_idelem %)',iloscpoz,_in.rc_ilosc,_in.tel_idelem_for;

  INSERT INTO tg_ruchy 
   (tel_idelem,tr_idtrans,ttw_idtowaru,
    ttm_idtowmag,tmg_idmagazynu,
    rc_data,
    rc_ilosc,rc_iloscpoz,
    rc_flaga,
    k_idklienta,rc_seqid,
    prt_idpartiiwz)
  VALUES
   (_in.tel_idelem_for,_in.tr_idtrans_for,_in.ttw_idtowaru,
    _in.ttm_idtowmag,_in.tmg_idmagazynu,
    _in.data_rezerwacji,
    round(iloscpoz,4),round(iloscpoz,4),
    1+flaga,
    abs(_in.k_idklienta_for),ret.rezid,
    _in.prt_idpartii); 

 END IF;

 DELETE FROM tg_ruchy WHERE tel_idelem=_in.tel_idelem_for AND NOT RCisRezerwacjaR(rc_flaga) AND rc_ilosc=0;

 RETURN ret;
END; 
$_$;
