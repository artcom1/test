CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
---WSPOK
DECLARE
 _in          ALIAS FOR $1;
 _dodelete    ALIAS FOR $2;

 ruch_data    RECORD;        --- Ruch data

 iloscdorez   NUMERIC;

 flaga        INT:=2;
 flagalocal   INT:=0;
 wspmag       INT:=1;

 idruchu      INT;

 iloscpoz     NUMERIC;
 wartoscpoz   NUMERIC;

 ilosctmp     NUMERIC;
 wartosctmp   NUMERIC;
 ilosctmprez  NUMERIC;

 ruchlast     INT;

 ret          gm.DODAJ_PZ_RETTYPE;
 wspwrt       NUMERIC:=1;
BEGIN
 
 IF (COALESCE(_in._istransodwrocona,FALSE)=TRUE) THEN
  wspwrt=-wspwrt;
  _in.tel_wartosc=-_in.tel_wartosc;
 END IF;
 
 ret.wartosc=floorRound(_in.tel_wartosc);
 iloscdorez=min(_in.tel_iloscf,nullZero(_in.tel_iloscrez));

 IF (iloscdorez>0) THEN   --- Zapewnij sobie ze nie wezma tego rezerwacje
  flaga=flaga|2048;
 END IF;

 IF (_in._isapz=TRUE) THEN
  flaga=4;
  wspmag=0;
  iloscdorez=0;
  ret.wartosc=0;
  _in.rc_cenajmcrs=NULL;
 END IF;

 /* --------Sprawdz czy nie bylo 0 ----------------------------------------- */

 IF (_in.tel_iloscf=0) THEN --- Ilosc jest zerowa, wiec skasuj wszystkie ruchy
  DELETE FROM tg_ruchy WHERE tel_idelem=_in.tel_idelem AND (tex_idelem IS NOT DISTINCT FROM _in.tex_idelem) AND (isPZet(rc_flaga) OR isAPZet(rc_flaga));
  ret.wartosc=0;
  RETURN ret;
 END IF;

 IF (_in.prt_idpartii IS NULL) THEN
  _in.prt_idpartii=gm.getIDNULLPartii(_in.ttw_idtowaru,TRUE,1);
 END IF;

 _in._iskonsygnata=COALESCE(_in._iskonsygnata,FALSE);
 
 
 /* --------Sprawdz istniejace---------------------------------------------- */
 IF (_in._iskonsygnata=TRUE) THEN
  flaga=flaga|(1<<29);
 END IF;

 iloscpoz=_in.tel_iloscf;
 wartoscpoz=ret.wartosc;

 --- Szukaj istniejacych rekordow
 FOR ruch_data IN SELECT rc_idruchu,rc_ilosc,rc_wartosc,rc_wartoscpoz,rc_flaga,mm_idmiejsca,rc_iloscpoz,prt_idpartiipz,rc_iloscrez,rc_wspwartosci,mrpp_idpalety
                  FROM tg_ruchy 
		          WHERE tel_idelem=_in.tel_idelem AND 
		                (tex_idelem IS NOT DISTINCT FROM _in.tex_idelem) AND
		                (isPZet(rc_flaga) OR isAPZet(rc_flaga)) 
	              ORDER BY isPZet(rc_flaga) DESC,rc_idruchu DESC
 LOOP
  ilosctmp=min(ruch_data.rc_ilosc,iloscpoz);
  flagalocal=flaga;
  
  IF (isPZet(ruch_data.rc_flaga)=TRUE) THEN
   IF (ruch_data.rc_wspwartosci IS DISTINCT FROM wspwrt) THEN
    RAISE EXCEPTION 'Blad wspolczynnika wartosci!';
   END IF;
   IF (ruch_data.mrpp_idpalety IS NULL) THEN
    ruchlast=ruch_data.rc_idruchu;
   END IF;
   ilosctmprez=0;
   IF (_in._isapz=TRUE) THEN
    RAISE EXCEPTION 'Dokument ma juz zamkniete operacje PZ';
   END IF;
  ELSE
   ilosctmprez=min(ilosctmp,iloscdorez);
  END IF;

  IF (_in.prt_idpartii IS DISTINCT FROM ruch_data.prt_idpartiipz) THEN
   IF (ruch_data.rc_iloscpoz<>ruch_data.rc_ilosc) OR (ruch_data.rc_iloscrez>0) THEN
    RAISE EXCEPTION 'Nie zgadza sie partia PZ (%<>%)!',_in.prt_idpartii,ruch_data.prt_idpartiipz;
   END IF;
  END IF;

  IF (ruch_data.mm_idmiejsca IS NULL) AND (ruch_data.mrpp_idpalety IS NULL) THEN
   ruchlast=ruch_data.rc_idruchu;
  END IF;

  IF (ilosctmprez=0) THEN
   flagalocal=flagalocal&(~2048);
  END IF;

  -- Wylicz proporcje - wez wszystko lub proporcjonalnie do ilosci
  IF (ilosctmp=iloscpoz)  THEN
   wartosctmp=wartoscpoz;
  ELSIF (ruch_data.rc_iloscpoz=0) THEN
   wartosctmp=ruch_data.rc_wartosc*wspwrt;
  ELSE
   wartosctmp=floorRoundMax(ret.wartosc*ilosctmp/_in.tel_iloscf,wartoscpoz);
  END IF;

  IF (ilosctmp=0) THEN
   --- Zostalo 0 - skasuj rekord
   DELETE FROM tg_ruchy WHERE rc_idruchu=ruch_data.rc_idruchu;
  ELSE
   --- Zmienila sie ilosc/wartosc - zmodyfikuj rekord
   UPDATE tg_ruchy SET 
   k_idklienta=_in.k_idklienta,
   rc_ilosc=round(ilosctmp,4),
   rc_iloscpoz=round(rc_iloscpoz,4)+round(ilosctmp-ruch_data.rc_ilosc,4),
   rc_wartosc=wartosctmp*wspwrt,
   rc_wartoscpoz=(wartosctmp-(rc_wartosc-rc_wartoscpoz)*wspwrt)*wspwrt,
   rc_flaga=(rc_flaga&(~4))|flagalocal,
   rc_iloscrezzr=(CASE WHEN rc_flaga&6=4 AND flaga&2=2 THEN 0 ELSE rc_iloscrezzr END),
   rc_wspmag=wspmag,
   prt_idpartiipz=_in.prt_idpartii,
   rc_cenajmcrs=_in.rc_cenajmcrs
  WHERE 
   rc_idruchu=ruch_data.rc_idruchu AND
   (
    k_idklienta<>_in.k_idklienta OR 
    rc_ilosc<>round(ilosctmp,4) OR
    rc_wartosc*wspwrt<>wartosctmp OR
    rc_flaga&flagalocal<>flagalocal OR
    prt_idpartiipz<>_in.prt_idpartii OR
	rc_cenajmcrs IS DISTINCT FROM _in.rc_cenajmcrs
   );
  END IF;

  IF (ilosctmprez>0) THEN
   --Zaloz rezerwacje na te partie
   ---RAISE EXCEPTION 'Ilosctmp p % ',ilosctmprez;
   PERFORM dodaj_rezerwacjea_partia(_in.tel_idelem,_in.tel_idelem,_in.tr_idtrans,_in.ttm_idtowmag,ilosctmprez,ruch_data.rc_idruchu);
   --I zdejmij bit blokady rezerwacji
   UPDATE tg_ruchy SET rc_flaga=rc_flaga&(~2048) WHERE rc_idruchu=ruch_data.rc_idruchu AND isPZet(rc_flaga);
  END IF;

  ---Odejmij pozostalosc
  iloscpoz=iloscpoz-ilosctmp;
  wartoscpoz=wartoscpoz-wartosctmp;
  iloscdorez=iloscdorez-ilosctmprez;
 END LOOP;

 -- Dla awiza tylko pilnujemy by nie bylo wiecej - nie zwiekszamy ilosci
 IF (_in._isapz=TRUE) THEN
  RETURN ret;
 END IF;

 --Przybylo na ilosci - zwieksz ilosc na ostatnim rekordzie
 IF (iloscpoz>0) AND (ruchlast IS NOT NULL) THEN
  flagalocal=flaga;

  ilosctmprez=min(iloscdorez,iloscpoz);

  IF (ilosctmprez=0) THEN
   flagalocal=flagalocal&(~2048);
  END IF;

  --- Zmienila sie ilosc/wartosc - zmodyfikuj rekord
  UPDATE tg_ruchy SET k_idklienta=_in.k_idklienta,
                      rc_ilosc=rc_ilosc+iloscpoz,
                      rc_iloscpoz=round(rc_iloscpoz,4)+round(iloscpoz,4),
                      rc_wartosc=((rc_wartosc*rc_wspwartosci)+wartoscpoz)*rc_wspwartosci,
                      rc_wartoscpoz=((rc_wartoscpoz*rc_wspwartosci)+wartoscpoz)*rc_wspwartosci,
                      rc_iloscrezzr=(CASE WHEN rc_flaga&6=4 AND flaga&2=2 THEN 0 ELSE rc_iloscrezzr END),
                      rc_flaga=(rc_flaga&(~4))|flagalocal,
					  rc_cenajmcrs=_in.rc_cenajmcrs,
					  rc_wspwartosci=wspwrt
                   WHERE rc_idruchu=ruchlast;

  IF (ilosctmprez>0) THEN
   --Zaloz rezerwacje na te partie
   PERFORM dodaj_rezerwacjea_partia(_in.tel_idelem,_in.tel_idelem,_in.tr_idtrans,_in.ttm_idtowmag,ilosctmprez,ruchlast);
   --I zdejmij bit blokady rezerwacji
   UPDATE tg_ruchy SET rc_flaga=rc_flaga&(~2048) WHERE rc_idruchu=ruch_data.rc_idruchu AND isPZet(rc_flaga);

   iloscdorez=iloscdorez-ilosctmprez;
  END IF;

  ---- Wyzeruj pozostala ilosc
  iloscpoz=0;
  wartoscpoz=0;
 END IF;

 IF (iloscpoz>0) THEN

  INSERT INTO tg_ruchy 
   (tel_idelem,tr_idtrans,ttw_idtowaru,ttm_idtowmag,tmg_idmagazynu,
    rc_data,
    rc_ilosc,rc_iloscpoz,
    rc_flaga,
    rc_wartosc,rc_wartoscpoz,
    k_idklienta,rc_kierunek,prt_idpartiipz,
    tex_idelem,
	rc_cenajmcrs,
	rc_wspwartosci
	) 
  VALUES 
   (_in.tel_idelem,_in.tr_idtrans,_in.ttw_idtowaru,_in.ttm_idtowmag,_in.tmg_idmagazynu,
   _in.rc_data,
   round(iloscpoz,4),round(iloscpoz,4),
   gm.addMRPPaletaSafeFlag(flaga),
   wartoscpoz*wspwrt,wartoscpoz*wspwrt,
   _in.k_idklienta,1,_in.prt_idpartii,
   _in.tex_idelem,
   _in.rc_cenajmcrs,
   wspwrt); 

  idruchu=(SELECT currval('tg_ruchy_s'));
 END IF;

 IF (idruchu IS NOT NULL AND iloscdorez>0) THEN
  --Zaloz rezerwacje na te partie
  PERFORM dodaj_rezerwacjea_partia(_in.tel_idelem,_in.tel_idelem,_in.tr_idtrans,_in.ttm_idtowmag,iloscdorez,idruchu);
  --I zdejmij bit blokady rezerwacji
  UPDATE tg_ruchy SET rc_flaga=rc_flaga&(~2048) WHERE rc_idruchu=idruchu AND isPZet(rc_flaga);
 END IF;

 --- Upewnij sie ze jest tyle ile chcielismy
 IF (iloscdorez>0) AND (_in._isapz=FALSE) THEN
  --Od nowa szukamy wszystkich rezerwacji
  iloscdorez=max(0,min(_in.tel_iloscf,nullZero(_in.tel_iloscrez)));

  FOR ruch_data IN SELECT * 
                   FROM tg_ruchy 
                   WHERE tel_idelem=_in.tel_idelem AND isRezerwacja(rc_flaga) 
		         AND tex_idelem IS NOT DISTINCT FROM _in.tex_idelem
		   ORDER BY rc_idruchu
  LOOP
   ilosctmprez=min(ruch_data.rc_iloscrez,iloscdorez);

   IF (ilosctmprez=0) THEN
    DELETE FROM tg_ruchy WHERE rc_idruchu=ruch_data.rc_idruchu;
   END IF;
   IF (ilosctmprez<ruch_data.rc_iloscrez) THEN
    ilosctmp=ruch_data.rc_iloscrez-ilosctmprez;   -- O ile za duzo

    UPDATE tg_ruchy SET rc_ilosc=rc_ilosc-ilosctmp WHERE rc_idruchu=ruch_data.rc_idruchu;
   END IF;

   iloscdorez=iloscdorez-ilosctmprez;
  END LOOP;
 ELSE
  IF (_in._isapz=FALSE) AND (_in.tel_iloscrez=0) THEN 
   DELETE FROM tg_ruchy WHERE isRezerwacja(rc_flaga) AND tel_idelem=_in.tel_idelem;
  END IF;
 END IF;
 
 RETURN ret;
END; 
$_$;
