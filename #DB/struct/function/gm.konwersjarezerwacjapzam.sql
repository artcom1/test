CREATE FUNCTION konwersjarezerwacjapzam(konwersjarezerwacjapzam_type) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _in          ALIAS FOR $1;
 ruch_data    RECORD;
 pozostalo    NUMERIC;
 ile          NUMERIC;
 _idpzam_tr   INT;
 shouldUpdate BOOL:=FALSE;
 trs          gm.PUSH_REZSTACK_TYPE;
 sr           gm.SKOPIUJ_REZERWACJE_TYPE;
 srret        gm.SKOPIUJ_REZERWACJE_RETTYPE;
 q            TEXT;
 pap          tg_partie;
 tmpint       INT;

 onlyonstan   BOOL:=FALSE;
 oorecno      INT:=0;
BEGIN


 IF (_in.tel_idelem_pzam IS NULL) THEN RETURN 0; END IF;


 --Na tyle ma byc rezerwacja wykorzystana i niewykorzystana
 pozostalo=_in.rc_ilosc;

 ---RAISE NOTICE 'Bede konwertowal % z zamowienia % dla %',pozostalo,_in.tel_idelem_pzam,_in.tel_idelem_fv;

 _idpzam_tr=(SELECT tr_idtrans FROM tg_transelem WHERE tel_idelem=_in.tel_idelem_pzam);---- AND tel_flaga&256=256);

 IF (_idpzam_tr IS NULL) THEN RETURN 0; END IF;
 
 IF (_in.ttw_whereparams IS NULL) OR (_in.ttw_inoutmethod IS NULL) THEN
  _in.ttw_whereparams=(SELECT ttw_whereparams FROM tg_towary JOIN tg_towmag USING (ttw_idtowaru) WHERE ttm_idtowmag=_in.ttm_idtowmag);
  _in.ttw_inoutmethod=(SELECT ttw_inoutmethod FROM tg_towary JOIN tg_towmag USING (ttw_idtowaru)WHERE ttm_idtowmag=_in.ttm_idtowmag);
 END IF;

 ---RAISE NOTICE '% % ',_in.tel_idelem_fv,_in.tex_idelem_fv;

 --- Najpierw wez rezerwacje fakturowe - 
 --- Najpierw przepisuj na pzam te z przyszlosci
 q='SELECT r.rc_idruchu,r.rc_ilosc-r.rc_iloscrezzr AS rc_oczekuje,r.rc_ilosc,rs.rs_id,
           gm.isPartiaEqual(ppz,ip,'||gm.toString(_in.ttw_whereparams)||','||gm.toString(_in.prt_idpartii)||') AS isok,
	   isRezerwacjaLekka(r.rc_flaga) AS islekka
    FROM tg_ruchy AS r
    LEFT OUTER JOIN tg_ruchy AS rpz ON (rpz.rc_idruchu=r.rc_ruch)
    LEFT OUTER JOIN tg_partie AS ppz ON (ppz.prt_idpartii=rpz.prt_idpartiipz)
    LEFT OUTER JOIN tg_partie AS ip ON (ip.prt_idpartii='||_in.prt_idpartii||')
    LEFT OUTER JOIN gm.tg_rezstack AS rs ON (rs.rc_idruchu=r.rc_idruchu AND rs.rc_recver_new=r.rc_recver)
    WHERE RCisRezerwacjaA(r.rc_flaga) AND 
   	 (r.tel_idelem='||_in.tel_idelem_fv||') AND 
	 (r.tex_idelem IS NOT DISTINCT FROM '||gm.toString(_in.tex_idelem_fv)||') AND
	 (r.ttm_idtowmag='||_in.ttm_idtowmag||') 
	 ORDER BY (r.rc_iloscrez=0) ASC,(rs.rs_id IS NULL) ASC,r.rc_dataop ASC,r.rc_idruchu ASC';
 FOR ruch_data IN EXECUTE q
 LOOP
---  RAISE NOTICE 'Do przep % i % (ruch % ilosc %) (RS %)',pozostalo,ruch_data.rc_oczekuje,ruch_data.rc_idruchu,ruch_data.rc_ilosc,ruch_data.rs_id;
  pozostalo=pozostalo-ruch_data.rc_oczekuje;

  IF (ruch_data.isok=FALSE) AND (ruch_data.islekka=FALSE) THEN
   --Nie zgadzaja sie partie - zwroc wszystko
   pozostalo=-ruch_data.rc_oczekuje;
  END IF;

  IF (pozostalo<0) THEN --- Przepiszemy rezerwacje na PZAM - bo juz sa niepotrzebne
   IF (pozostalo=-ruch_data.rc_oczekuje) THEN
    --- Sproboj przekonwertowac rezerwacje
    IF (gm.popRezStack(ruch_data.rc_idruchu)=FALSE) THEN
     --- Nie udalo sie - skasuj ja
     DELETE FROM tg_ruchy WHERE rc_idruchu=ruch_data.rc_idruchu;
    END IF;
   ELSE
    sr=NULL;
    sr.rc_idruchu_src=ruch_data.rc_idruchu;
    sr.tel_idelem_dst=_in.tel_idelem_fv;
    sr.tex_idelem_dst=_in.tex_idelem_fv;
    sr.tr_idtrans_dst=_in.tr_idtrans_fv;
    sr.rc_ilosctocopy=-pozostalo;
    sr.rc_addflaga=0;
    sr._leaveflags=TRUE;
    ---RAISE NOTICE 'Do skopiowania %',sr;
    srret=gm.skopiujrezerwacje(sr);
    sr.rc_addflaga=(SELECT rc_flaga FROM tg_ruchy WHERE rc_idruchu=srret.rc_idruchu_new);
    ---RAISE NOTICE 'Mam % ',sr.rc_addflaga;
    ---RAISE NOTICE 'Skopiowalem % z zamowienia % dla % (nowy ruch %)',-pozostalo,_in.tel_idelem_pzam,_in.tel_idelem_fv,srret.rc_idruchu_new;
    IF (gm.popRezStack(srret.rc_idruchu_new)=FALSE) THEN
     --- Nie udalo sie - skasuj ja
     DELETE FROM tg_ruchy WHERE rc_idruchu=srret.rc_idruchu_new;
    END IF;
   END IF;
   shouldUpdate=TRUE;
  END IF;
  pozostalo=max(pozostalo,0);
 END LOOP;

 ---RAISE NOTICE 'Do dobrania % z zamowienia % dla %',pozostalo,_in.tel_idelem_pzam,_in.tel_idelem_fv;


 --- Porusz PZAM
 IF (shouldUpdate=TRUE) THEN
  ----UPDATE tg_transelem SET tel_idelem=tel_idelem WHERE tel_idelem=_in.tel_idelem_pzam;
  INSERT INTO gm.tg_tetotouch (tel_idelem) VALUES (_in.tel_idelem_pzam);
  shouldUpdate=FALSE;
 END IF;

 --Trzeba cos dobrac z pzamow
 --Najpierw przepisuj te ktore maja PZety
 IF (pozostalo>0) THEN
  SELECT * INTO pap FROM tg_partie WHERE prt_idpartii=_in.prt_idpartii;

  LOOP 
   onlyonstan=NOT onlyonstan;

   q='SELECT r.rc_idruchu,r.rc_ilosc-r.rc_iloscrezzr AS rc_oczekuje,r.tel_idelem,
             r.prt_idpartiiwz,r.rc_flaga,r.rc_recver,r.tex_idelem,
	     r.rc_iloscrez
      FROM tg_ruchy AS r 
      LEFT OUTER JOIN tg_partie AS p ON (p.prt_idpartii=r.prt_idpartiiwz)
      LEFT OUTER JOIN tg_ruchy AS rpz ON (rpz.rc_idruchu=r.rc_ruch)
      LEFT OUTER JOIN tg_partie AS ppz ON (ppz.prt_idpartii=rpz.prt_idpartiipz)
      LEFT OUTER JOIN tg_partie AS ip ON (ip.prt_idpartii='||_in.prt_idpartii||')
	  '||gm.getinoutjoinclause(_in.ttw_inoutmethod,'rpz')||'
      WHERE /*RCisRezerwacjaA(r.rc_flaga) AND */ isRezerwacja(r.rc_flaga) AND
           (r.tel_idelem='||_in.tel_idelem_pzam||') AND 
   	   (r.ttm_idtowmag='||_in.ttm_idtowmag||')  AND
	   (
	    (rpz.rc_idruchu IS NOT NULL '||gm.getWhereClause('ppz',pap,_in.ttw_whereparams)||') OR
	    (rpz.rc_idruchu IS NULL AND gm.isPartiaWZEqual(p,ip,'||_in.ttw_whereparams||')) OR
	    isRezerwacjaLekka(r.rc_flaga)
	   )
     ORDER BY ((r.rc_iloscrez!=0) AND NOT isRezerwacjaLekka(r.rc_flaga)) DESC,'||
     gm.getinoutsortclause(_in.ttw_inoutmethod,'rpz','ppz',FALSE)||
     ',rpz.rc_idruchu DESC';
  ----RAISE NOTICE '%',gm.toNotice(q);
   FOR ruch_data IN EXECUTE q
   LOOP
    ----Zwieksz licznik rekordow
    oorecno=oorecno+1;
    ---Oblicz ilosc
    IF (onlyonstan=TRUE) THEN
     ile=min(pozostalo,ruch_data.rc_iloscrez);
    ELSE
     ile=min(pozostalo,ruch_data.rc_oczekuje);
    END IF;
    --------------------------------------------------------------------------
    IF (ile>0) THEN --- Przepiszemy rezerwacje na PZAM
     IF (ile=ruch_data.rc_oczekuje) THEN
      ----RAISE NOTICE 'Przepisuje w calosci % z ruchu % ',ile,ruch_data.rc_idruchu;
      tmpint=nextval('gm.tg_rezstack_ver');
      UPDATE tg_ruchy SET tel_idelem=_in.tel_idelem_fv,
                          tex_idelem=_in.tex_idelem_fv,
                          tr_idtrans=_in.tr_idtrans_fv,
 			 rc_flaga=rc_flaga&(~(1<<19)),
 			 rc_recver=tmpint
 		     WHERE rc_idruchu=ruch_data.rc_idruchu;
      trs=NULL;
      trs.tel_idelem_old=ruch_data.tel_idelem;
      trs.tel_idelem_new=_in.tel_idelem_fv;
      trs.tex_idelem_old=ruch_data.tex_idelem;
      trs.tex_idelem_new=_in.tex_idelem_fv;
      trs.prt_idpartii_old=ruch_data.prt_idpartiiwz;
      trs.prt_idpartii_new=_in.prt_idpartii;
      trs.rc_flaga_old=ruch_data.rc_flaga;
      trs.rc_recver_old=ruch_data.rc_recver;
      trs.rc_recver_new=tmpint;
      PERFORM gm.pushRezStack(ruch_data.rc_idruchu,trs);
     ELSE
      ---RAISE NOTICE 'Przepisuje w czesci %/% z ruchu % ',ile,ruch_data.rc_oczekuje,ruch_data.rc_idruchu;
      ---Skopiuj rezerwacje
      sr=NULL;
      sr.rc_idruchu_src=ruch_data.rc_idruchu;
      sr.tel_idelem_dst=_in.tel_idelem_fv;
      sr.tex_idelem_dst=_in.tex_idelem_fv;
      sr.tr_idtrans_dst=_in.tr_idtrans_fv;
      sr.rc_ilosctocopy=ile;
      sr.rc_addflaga=0;
      srret=gm.skopiujrezerwacje(sr);
      /*
      ---Odloz na stos
      trs=NULL;
      trs.tel_idelem_old=ruch_data.tel_idelem;
      trs.tex_idelem_old=ruch_data.tex_idelem;
      trs.tel_idelem_new=_in.tel_idelem_fv;
      trs.tex_idelem_new=_in.tex_idelem_fv;
      trs.prt_idpartii_old=ruch_data.prt_idpartiiwz;
      trs.prt_idpartii_new=_in.prt_idpartii;
      trs.rc_flaga_old=ruch_data.rc_flaga;
      trs.rc_recver_old=ruch_data.rc_recver;
      trs.rc_recver_new=srret.rc_recver_new;
      PERFORM gm.pushRezStack(srret.rc_idruchu_new,trs);
      */
     END IF;
     shouldUpdate=TRUE;
    END IF;
    pozostalo=pozostalo-ile;
   END LOOP;
   EXIT WHEN (onlyonstan=FALSE) OR (pozostalo<=0) OR (oorecno=0);
  END LOOP;
 END IF;

 --- Porusz PZAM
 IF (shouldUpdate=TRUE) THEN
  ---UPDATE tg_transelem SET tel_idelem=tel_idelem WHERE tel_idelem=_in.tel_idelem_pzam;
  INSERT INTO gm.tg_tetotouch (tel_idelem) VALUES (_in.tel_idelem_pzam);
  shouldUpdate=FALSE;
 END IF;

 RETURN 0;
END;
$_$;
