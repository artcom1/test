CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN gm.movepz($1,$2,$3,false,false);
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN gm.movepz($1,$2,$3,$4,false);
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
---WSPOK
DECLARE
 _idruchu            ALIAS FOR $1;
 _idmiejscanew       ALIAS FOR $2;
 _iloscf             ALIAS FOR $3;
 _alwaysmove         ALIAS FOR $4;
 _donullmiejscemag   ALIAS FOR $5;
 r                   RECORD;
 rr                  RECORD;
 iloscRezerwacji     NUMERIC;
 ret                 INT;
 wartosc             NUMERIC;
 dostawa             INT;
 flag                INT:=0;
 iloscRezerwacjiLeft NUMERIC;
 tmp                 NUMERIC;
 cr                  gm.SKOPIUJ_REZERWACJE_TYPE;
BEGIN

 SELECT * FROM tg_ruchy INTO r WHERE rc_idruchu=_idruchu AND (isPZet(rc_flaga) OR isAPZet(rc_flaga));
 IF (r.rc_idruchu IS NULL) THEN
  RAISE EXCEPTION 'Nie znaleziono podanego elementu!';
 END IF;
 
 
 IF (r.mrpp_idpalety IS NOT NULL) THEN
  IF (_idmiejscanew IS NOT NULL) OR (_donullmiejscemag=TRUE) THEN
   IF (r.mm_idmiejsca IS DISTINCT FROM _idmiejscanew) THEN
    SELECT * INTO rr FROM tr_mrppalety WHERE mrpp_idpalety=r.mrpp_idpalety;
	IF (rr.mm_idmiejsca IS DISTINCT FROM _idmiejscanew) THEN
--     IF (gm.istriggerfunctionactive('MRPPALETALLOWCHANGEMMAG',r.mrpp_idpalety)=TRUE) THEN
      RAISE EXCEPTION '54|%|Nie mozna przeniesc czesci palety',r.rc_idruchu;
--	 END IF;
    END IF;
   END IF;
  END IF;
 END IF;

 IF (r.rc_iloscpoz<_iloscf) THEN
  RAISE EXCEPTION 'Nie mozna przeniesc podanej ilosci (dostepne % do przeniesienia %)',r.rc_iloscpoz,_iloscf;
 END IF;

 --- Tyle rezerwacji zostalo do zrealizowania
 iloscRezerwacji=r.rc_iloscrez-r.rc_iloscrezzr;
 --- Tyle zostanie na PZecie
 iloscRezerwacji=max(iloscRezerwacji-(r.rc_iloscpoz-_iloscf),0);

 IF isAPZet(r.rc_flaga) AND (r.rc_iloscpoz-r.rc_iloscrezzr<_iloscf) THEN
  iloscRezerwacji=_iloscf-(r.rc_iloscpoz-r.rc_iloscrezzr);
  --- Na PZetach mozna przenosic miedzy miejscami magazynowymi ale na APZetach nie :)
  RAISE EXCEPTION 'Nie mozna przenosic potwierdzonej ilosci (za duzo o %)',iloscRezerwacji;
 END IF;

 IF (r.rc_iloscpoz=_iloscf) AND (_alwaysmove=FALSE) THEN
  IF (_idmiejscanew IS NOT NULL) OR (_donullmiejscemag=TRUE) THEN
   UPDATE tg_ruchy SET mm_idmiejsca=_idmiejscanew WHERE rc_idruchu=_idruchu;
  END IF;
  RETURN _idruchu;
 END IF;

 wartosc=floorRoundMax(_iloscf*r.rc_wartoscpoz*r.rc_wspwartosci/r.rc_iloscpoz,r.rc_wartoscpoz*r.rc_wspwartosci);

 dostawa=NULL;
 IF (r.rc_dostawa<>r.rc_idruchu) THEN dostawa=r.rc_dostawa; END IF;

 --- Jesli jest rezerwacja i ruch nie ma blokady rezerwacji to naloz ja
 IF (iloscRezerwacji<>0) AND ((r.rc_flaga&2048)=0) THEN
  UPDATE tg_ruchy SET rc_flaga=rc_flaga|2048 WHERE rc_idruchu=_idruchu;
  flag=flag|2048;
 END IF;

 SELECT * INTO rr FROM tg_ruchy AS rt WHERE rt.tel_idelem=r.tel_idelem AND 
                                            rt.ttm_idtowmag=r.ttm_idtowmag AND
					                        (rt.rc_flaga&6)=(r.rc_flaga&6) AND
					                        rt.prt_idpartiipz IS NOT DISTINCT FROM r.prt_idpartiipz AND
					                        rt.tex_idelem IS NOT DISTINCT FROM r.tex_idelem AND
					                        (CASE WHEN dostawa IS NOT NULL THEN rt.rc_dostawa=dostawa ELSE TRUE END) AND
					                        COALESCE(rt.mm_idmiejsca,0)=COALESCE(_idmiejscanew,0) AND
											rt.rc_wspwartosci=r.rc_wspwartosci AND
											rt.mrpp_idpalety IS NOT DISTINCT FROM r.mrpp_idpalety AND
					                        (_alwaysmove=FALSE) 
					                        LIMIT 1;
 IF rr.rc_idruchu IS NOT NULL THEN
  UPDATE tg_ruchy SET rc_ilosc=rc_ilosc+_iloscf,
                      rc_wartosc=rc_wartosc+wartosc*r.rc_wspwartosci,
		              rc_iloscpoz=rc_iloscpoz+_iloscf,
		              rc_wartoscpoz=rc_wartoscpoz+wartosc*r.rc_wspwartosci,
		              rc_flaga=rc_flaga|flag
		          WHERE rc_idruchu=rr.rc_idruchu;
  ret=rr.rc_idruchu;
 ELSE
  ---Dodaj nowy ruch PZetowy z podana iloscia
  INSERT INTO tg_ruchy
   (tel_idelem,tr_idtrans,ttw_idtowaru,ttm_idtowmag,tmg_idmagazynu,
    k_idklienta,rc_data,rc_dataop,
    rc_ilosc,rc_wartosc,rc_iloscpoz,rc_wartoscpoz,
    rc_iloscrez,rc_iloscrezzr,rc_kierunek,rc_kierunekrez,
    rc_odn,rc_flaga,rc_cenajedn,rc_dostawa,rc_wspmag,
    rc_seqid,mm_idmiejsca,
    tex_idelem,prt_idpartiipz,
	rc_wspwartosci,
	mrpp_idpalety
	)
   VALUES
    (r.tel_idelem,r.tr_idtrans,r.ttw_idtowaru,r.ttm_idtowmag,r.tmg_idmagazynu,
     r.k_idklienta,r.rc_data,r.rc_dataop,
     _iloscf,wartosc*r.rc_wspwartosci,_iloscf,wartosc*r.rc_wspwartosci,
     0,0,r.rc_kierunek,r.rc_kierunekrez,
     0,gm.addMRPPaletaSafeFlag(r.rc_flaga|flag),r.rc_cenajedn,dostawa,r.rc_wspmag,
     r.rc_seqid,_idmiejscanew,
     r.tex_idelem,r.prt_idpartiipz,
	 r.rc_wspwartosci,
	 r.mrpp_idpalety
	 );
   
  --- Wez ID stworzonego ruchu
  ret=(SELECT currval('tg_ruchy_s'));
  
  IF (gm.isAnyOznaczonyRuchN()=TRUE AND gm.isOznaczonyRuchN(_idruchu)=TRUE) THEN
   PERFORM gm.copyOznaczenia(_idruchu,ret);
  END IF;
  
 END IF;

 
 IF (iloscRezerwacji>0) THEN
  ---- Zablokuj pierwotny rekord
  iloscRezerwacjiLeft=iloscRezerwacji;

  FOR rr IN SELECT * FROM tg_ruchy WHERE isRezerwacja(rc_flaga) AND rc_ruch=r.rc_idruchu AND rc_ilosc>rc_iloscrezzr ORDER BY rc_iloscrez ASC,rc_idruchu DESC
  LOOP
   EXIT WHEN (iloscRezerwacjiLeft<=0);

   tmp=min(iloscRezerwacjiLeft,rr.rc_iloscrez);

   cr=NULL;
   cr.rc_idruchu_src=rr.rc_idruchu;
   cr.tel_idelem_dst=rr.tel_idelem;
   cr.tr_idtrans_dst=rr.tr_idtrans;
   cr.rc_ilosctocopy=tmp;
   cr.rc_addflaga=0;
   cr.rc_delflaga=0;
   cr.rc_ruch_new=ret;
   cr._leaveflags=TRUE;
   PERFORM gm.skopiujRezerwacje(cr);

   iloscRezerwacjiLeft=iloscRezerwacjiLeft-tmp;
  END LOOP;

  IF (iloscRezerwacjiLeft>0) THEN
   RAISE EXCEPTION 'Przy rozdzieleniu PZetu nastapil blad przy przenoszeniu rezerwacji!';
  END IF;

 END IF;


 ---- Zmniejsz ilosc i wartosc
 UPDATE tg_ruchy SET rc_ilosc=rc_ilosc-_iloscf,
                     rc_wartosc=rc_wartosc-wartosc*r.rc_wspwartosci,
		             rc_iloscpoz=rc_iloscpoz-_iloscf,
		             rc_wartoscpoz=rc_wartoscpoz-wartosc*r.rc_wspwartosci
		         WHERE rc_idruchu=_idruchu;


 --- Zdejmij bit blokady rezerwacji
 IF ((flag&2048)=2048) THEN
  UPDATE tg_ruchy SET rc_flaga=rc_flaga&(~2048) WHERE rc_idruchu=ret;
  UPDATE tg_ruchy SET rc_flaga=rc_flaga&(~2048) WHERE rc_idruchu=_idruchu;
 END IF;

 RETURN ret;
END;
$_$;
