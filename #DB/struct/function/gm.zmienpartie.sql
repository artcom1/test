CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
---WSPOK
DECLARE
 _src ALIAS FOR $1;
 _dest ALIAS FOR $2;
 _ilosc ALIAS FOR $3;
 r RECORD;
 ilosc NUMERIC;
 m NUMERIC;
 op INT;
BEGIN

 SELECT tel_idelem,tr_idtrans INTO r FROM tg_ruchy WHERE rc_idruchu IN (_src,_dest) FOR UPDATE;
 SELECT rr.*,(CASE WHEN isFV(rr.rc_flaga) THEN rr.rc_iloscpoz WHEN isRezerwacja(rr.rc_flaga) THEN rr.rc_ilosc-rr.rc_iloscrezzr ELSE 0 END) AS ile,
        rrez.tel_idelem AS tel_idelemrez
 INTO r
 FROM tg_ruchy AS rr
 LEFT OUTER JOIN tg_ruchy AS rrez ON (rrez.rc_idruchu=rr.rc_rezerwacja)
 WHERE rr.rc_idruchu=_src;

 r.ile=min(r.ile,_ilosc);

 ----RAISE NOTICE 'Mam wartoscpoz % ',r.ile;

 IF (r.ile<=0) THEN RETURN 0; END IF;
 
 op=gm.nextOznaczRuchN();
 PERFORM gm.markAnyOznaczonyRuchN(op,TRUE);
 PERFORM gm.oznaczRuchN(op,_dest,TRUE);

 IF (isFV(r.rc_flaga)) THEN
  UPDATE tg_ruchy SET rc_ilosc=rc_ilosc-r.ile,
                      rc_iloscpoz=rc_iloscpoz-r.ile,
		              rc_wartosc=rc_wartosc-floorroundmax(r.ile*rc_cenajedn,rc_wartosc*rc_wspwartosci)*rc_wspwartosci,
		              rc_wartoscpoz=rc_wartoscpoz-floorroundmax(r.ile*rc_cenajedn,rc_wartoscpoz*rc_wspwartosci)*rc_wspwartosci
		  WHERE rc_idruchu=_src;
 ELSE
  IF (isRezerwacja(r.rc_flaga)) THEN
   IF (NOT RCisRezerwacjaR(r.rc_flaga)) THEN --- Rezerwacja automatyczna - wystarczy wiec zmniejszyc ilosc
    UPDATE tg_ruchy SET rc_ilosc=rc_ilosc-r.ile,
                        rc_iloscpoz=rc_iloscpoz-r.ile,
			            rc_wartosc=rc_wartosc-floorroundmax(r.ile*rc_cenajedn,rc_wartosc*rc_wspwartosci)*rc_wspwartosci,
			            rc_wartoscpoz=rc_wartoscpoz-floorroundmax(r.ile*rc_cenajedn,rc_wartoscpoz*rc_wspwartosci)*rc_wspwartosci
		            WHERE rc_idruchu=_src;
   ELSE --- Rezerwacja reczno - automatyczna, trzeba wiecej zachodu, bo trzeba skopiowac 
    --- Zmniejszyc ilosc na tej rezerwacji (max rc_ilosc-rc_iloscrezzr)
    UPDATE tg_ruchy SET rc_ilosc=round(rc_ilosc-r.ile,4) WHERE rc_idruchu=r.rc_idruchu;
    -- Dodac rezerwacje reczna na to o co zmniejszono (problem: byc moze znajdzie jakiegos PZeta)
    INSERT INTO tg_ruchy 
     (tel_idelem,tr_idtrans,ttw_idtowaru,ttm_idtowmag,tmg_idmagazynu,
      rc_data,rc_dataop,
      rc_ilosc,rc_iloscpoz,rc_iloscrez,
      rc_flaga,k_idklienta,
      rc_ruch,rc_seqid,prt_idpartiiwz)
    VALUES
     (NULL,NULL,r.ttw_idtowaru,r.ttm_idtowmag,r.tmg_idmagazynu,
      r.rc_data,r.rc_dataop,
      r.ile,max(0,r.ile-(r.rc_ilosc-r.rc_iloscpoz)),0,
      r.rc_flaga&(~256),r.k_idklienta,
      r.rc_ruch,r.rc_seqid,r.prt_idpartiiwz); 
    ---RAISE NOTICE 'Przeniesienie % %',r.ile;
    ---Ilosc_ktora_potrzebujemy - ilosc_dla_ktorej_nie_znaleziono_pz max(0,r.ile-(r.rc_ilosc-r.rc_iloscpoz))
   END IF;
  END IF;
 END IF;

 PERFORM checkZaksiegowanieDoc(r.tr_idtrans);

 UPDATE tg_transelem SET tel_idelem=tel_idelem,tel_newflaga=tel_newflaga|16 WHERE tel_idelem=r.tel_idelem;

 PERFORM gm.markAnyOznaczonyRuchN(op,FALSE);

 PERFORM checkZaksiegowanieDoc(tr_idtrans) FROM tg_transelem JOIN tg_transakcje USING (tr_idtrans) WHERE tel_idelem=(SELECT tel_skojlog FROM tg_transelem JOIN tg_transakcje USING (tr_idtrans) WHERE tel_idelem=r.tel_idelem) AND tr_rodzaj NOT IN (104);

 UPDATE tg_transelem SET tel_idelem=tel_idelem WHERE tel_idelem=(SELECT tel_skojlog FROM tg_transelem WHERE tel_idelem=r.tel_idelem);

 DELETE FROM tg_ruchy WHERE tel_idelem=r.tel_idelem AND rc_ilosc=0;
 
 IF (r.tel_idelemrez IS NOT NULL) THEN
  UPDATE tg_transelem SET tel_idelem=tel_idelem WHERE tel_idelem=r.tel_idelemrez;
 END IF;

 RETURN r.tel_idelem;
END;
$_$;
