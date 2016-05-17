CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN zmiananapzruch($1,$2,$3,TRUE);
END; $_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
--WSPOK
DECLARE
 _idruchu      ALIAS FOR $1;
 _ilosc        ALIAS FOR $2;
 _wartosc      ALIAS FOR $3;
 _updatetepz   ALIAS FOR $4;
 r RECORD;
 rin RECORD;
 elemy TEXT:='';
 rid INT;
 iloscrozd    NUMERIC;              ------ Ilosc do rozdysponowania
 wartoscrozd  NUMERIC;              ------ Wartosc do rozdysponowania
 wartosctmp   NUMERIC;              ------ Wartosc tymczasowa
 cenajm       NUMERIC;              ------ Cena jednostki miary

 iloscpozin   NUMERIC;              ------ Ilosc do skorygowania dla KWZ
 wartoscpozin NUMERIC;              ------ Wartosc do skorygowania dla KWZ

 iloscpoz NUMERIC; 
 wartoscpoz NUMERIC;

 tmp NUMERIC;
 t NUMERIC;
 
 wsp NUMERIC:=1;
BEGIN

 IF (_idruchu IS NULL) THEN
  RETURN '';
 END IF;
 
 IF (_wartosc<0) THEN
  wsp=-wsp;
  _wartosc=-_wartosc;
 END IF;

 ----RAISE NOTICE 'Zmiana ceny/ilosci na PZ dla ruchu % (% % wsp %)',_idruchu,_ilosc,_wartosc,wsp;

 --Sprawdz czy nie bylo korekty na cene
 rid=(SELECT kpz.tel_idelem FROM tg_transelem AS kpz,tg_ruchy AS rc,tg_transelem AS pz  WHERE (rc.rc_idruchu=_idruchu) AND pz.tel_idelem=rc.tel_idelem AND kpz.tel_skojarzony=rc.tel_idelem AND (pz.tel_cenawal<>kpz.tel_cenawal OR pz.tel_cenabwal<>kpz.tel_cenabwal) LIMIT 1);
 IF (rid IS NOT NULL) THEN
  SELECT tr_idtrans,tel_idelem INTO r FROM tg_transelem WHERE tel_idelem=rid;
  RAISE EXCEPTION '9|%:%|Nie mozna zmieniac ceny na korygowanym na cene PZecie',r.tr_idtrans,r.tel_idelem;
 END IF;

 UPDATE tg_ruchy SET rc_ilosc=_ilosc,
                     rc_wartosc=_wartosc*wsp,
					 rc_wartoscpoz=_wartosc*wsp-(rc_wartosc-rc_wartoscpoz),
					 rc_flaga=rc_flaga|(1<<21),rc_wspwartosci=wsp 
					 WHERE rc_idruchu=_idruchu;

 tmp=(SELECT rc_wartosc FROM tg_ruchy WHERE rc_idruchu=_idruchu);
 ---RAISE NOTICE 'Mam wartosc % %',tmp,_wartosc;

 tmp=(SELECT rc_wartoscpoz FROM tg_ruchy WHERE rc_idruchu=_idruchu);
 ---RAISE NOTICE 'Mam wartoscpoz % %',tmp,_wartosc;

 SELECT * INTO rin FROM tg_ruchy WHERE rc_idruchu=_idruchu;

 elemy=elemy||'|'||rin.tel_idelem;
 PERFORM checkZaksiegowanieDoc(rin.tr_idtrans);
 PERFORM checkblokadapozycjidozmiany(rin.tel_idelem);

 IF (_ilosc=0) AND (_wartosc=0) THEN
  cenajm=0;
 ELSE
  cenajm=round(_wartosc/_ilosc,4);
 END IF;

 iloscrozd=rin.rc_ilosc-rin.rc_iloscpoz;
 IF (rin.rc_iloscpoz=0) THEN
  wartoscrozd=_wartosc;
 ELSE
  wartoscrozd=floorRoundMax(cenajm*iloscrozd,_wartosc);
 END IF;

 ---wartoscrozd - wartosc ktora trzeba rozdzielic miedzy ruchy
 ---iloscrozd - ilosc ktora trzeba rozdzielic miedzy ruchy
 
 FOR r IN SELECT tg_ruchy.* FROM tg_ruchy WHERE tg_ruchy.rc_ruch=_idruchu AND rc_wspmag<0 AND NOT (rc_iloscpoz=0 AND (rc_flaga&(1<<27))<>0) ORDER BY rc_iloscpoz ASC, rc_dataop ASC
 LOOP
 
  IF (r.rc_wspwartosci!=wsp) THEN
   RAISE EXCEPTION 'Blad wspolczynnika wartosci';
  END IF;

  ---wartosctmp - wartosc z proporcji
  IF (r.rc_iloscpoz=iloscrozd) THEN
   ---RAISE NOTICE 'Tutaj jsetem % % ',r.rc_iloscpoz,iloscrozd;
   wartosctmp=wartoscrozd;
  ELSE
   wartosctmp=floorroundmax(r.rc_iloscpoz*cenajm,wartoscrozd);
  END IF;

  ----RAISE NOTICE 'Wartosc dla % wynosi % z % % %',r.rc_idruchu,wartosctmp,r.rc_ilosc,cenajm,wartoscrozd;

  --- Jesli wartosc jest podzielna rowniez moge normalnie postapic z rekordami
  iloscpozin=r.rc_ilosc-r.rc_iloscpoz;
  wartoscpozin=round(cenajm*iloscpozin,2);
  wartosctmp=wartosctmp+wartoscpozin;
  IF (wartosctmp-wartoscpozin>wartoscrozd) THEN
   wartoscpozin=wartoscpozin-(wartosctmp-wartoscpozin-wartoscrozd);
   wartosctmp=wartoscrozd;
  END IF;


  UPDATE tg_ruchy 
  SET rc_wartosc=wartosctmp*wsp,
      rc_wartoscpoz=(wartosctmp-(rc_wartosc-rc_wartoscpoz)*wsp)*wsp,
      rc_cenajedn=cenajm,
	  rc_wspwartosci=wsp
  WHERE rc_idruchu=r.rc_idruchu;          --- WartoscOrg moge zupdatowac normalnie

  elemy=elemy||'|'||r.tel_idelem||'|'||zmiananaPZRuchKWZ(r.rc_idruchu,iloscpozin,wartoscpozin*wsp);

  UPDATE tg_transelem SET tel_idelem=tel_idelem WHERE tel_idelem=r.tel_idelem;

  PERFORM checkZaksiegowanieDoc(r.tr_idtrans);
  iloscrozd=iloscrozd+r.rc_ilosc-r.rc_iloscpoz;
  wartoscrozd=wartoscrozd+wartoscpozin;

  rid=(SELECT rc_idruchu FROM tg_ruchy WHERE rc_wspmag=1 and rc_seqid=r.rc_seqid);
  IF (rid IS NOT NULL) THEN
   elemy=elemy||'|'||zmianaNaPZRuch(rid,r.rc_ilosc,wartosctmp*wsp);
  END IF;

  iloscrozd=iloscrozd-r.rc_iloscpoz;
  ---RAISE NOTICE 'Looopek przed % (%-(%-(%+%)*%))',wartoscrozd,wartoscrozd,wartosctmp,r.rc_wartosc,r.rc_wartoscpoz,wsp;
  ---wartoscrozd=wartoscrozd-(wartosctmp-(r.rc_wartosc+r.rc_wartoscpoz)*wsp);
  wartoscrozd=wartoscrozd-(wartosctmp-(r.rc_wartosc-r.rc_wartoscpoz)*wsp);
  ----RAISE NOTICE 'Looopek po %',wartoscrozd;
 END LOOP;


 IF (_updatetepz=TRUE) THEN
  UPDATE tg_transelem SET tel_idelem=tel_idelem WHERE tel_idelem=rin.tel_idelem;
  UPDATE tg_ruchy SET rc_flaga=rc_flaga&(~(1<<21)) WHERE rc_idruchu=_idruchu;
 END IF;

 RETURN elemy;
END;
$_$;
