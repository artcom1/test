CREATE FUNCTION kdodokcreate(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtrans    ALIAS FOR $1;
 _idkor      ALIAS FOR $2;
 rd          RECORD;
 ile_pozycji INT:=0;
 dsttrans    RECORD;
 maskf       INT:=0;
 hastex      BOOL:=FALSE;
 ------
 nextidm     INT;
 nextidp    INT;
 typzestawu  INT;
BEGIN

 SELECT tr_rodzaj INTO dsttrans FROM tg_transakcje WHERE tr_idtrans=_idkor;

 SET enable_mergejoin=off;
 
 CREATE TEMP TABLE rozmiarowkamap (oldteid INT,newteidm INT,newteidp INT);

 PERFORM vat.disableRecalcing(_idtrans,1);
 PERFORM vat.disableRecalcing(_idkor,1);

 ---Wydobycie wszystkich ostatnich pozycji na dokumencie uwzgledniajac pozycje dopisane na korektach
 FOR rd IN
  SELECT * FROM 
  (
   SELECT DISTINCT ON (id) pozycje.* FROM
   (
    SELECT * FROM 
    (
     ---Wyodrebnij pierwotne dokumenty
     SELECT tel_idelem AS id,tg_transelem.* FROM tg_transelem 
       WHERE tr_idtrans=_idtrans 
     UNION
     --Dolacz do tego pozycje korekt "wprost"
      SELECT COALESCE(tel_skojarzony,tel_idelem) AS id,tg_transelem.* FROM tg_transakcje JOIN tg_transelem USING (tr_idtrans)
      WHERE tr_skojarzona=_idtrans AND tr_rodzaj=dsttrans.tr_rodzaj AND (((tel_flaga&65536)=65536) OR (tel_skojarzony IS NULL)) 
     UNION
      --Dolacz do tego skorygowane tranelemy na korektach niewprost
      SELECT kte.tel_skojarzony AS id,kte.* FROM tg_transelem AS ste 
      JOIN tg_transelem AS kte ON (kte.tel_skojarzony=ste.tel_idelem AND kte.ttw_idtowaru=ste.ttw_idtowaru) 
      JOIN tg_transakcje ON (kte.tr_idtrans=tg_transakcje.tr_idtrans) 
      WHERE ste.tr_idtrans=_idtrans AND tr_rodzaj=dsttrans.tr_rodzaj AND ((kte.tel_flaga&65536)=65536) 
    ) AS a
    WHERE (tel_flaga&1024=0 OR tel_skojzestaw>0) AND tel_flaga&(1<<26)=0
    ORDER BY id ASC,tel_idelem DESC
  ) AS pozycje
  WHERE tel_flaga&(1<<7)=0
 ) AS a ORDER BY sortKonta(numerKonta(tel_lpprefix,tel_lp),5) ASC
 LOOP
  rd.tel_flaga=rd.tel_flaga&(1|2|4|8|32|64|128|2048|131072|1024|(1<<26)|(1<<31));
  rd.tel_newflaga=(rd.tel_newflaga&(7|256|14336|49152|524288|(1<<23)|(1<<16)));
  typzestawu=gmr.getTypZestawu(rd.tel_new2flaga);
  maskf=maskf|131072;

  SET enable_mergejoin=on;

  rd.tel_new2flaga=rd.tel_new2flaga|(1<<3);

  hastex=((rd.tel_new2flaga&3)<>0);
  rd.tel_new2flaga=rd.tel_new2flaga|(1<<4);
  IF (hastex=TRUE) THEN
   rd.tel_new2flaga=(rd.tel_new2flaga&(~3))|1;
  END IF;
  
  nextidm=nextval('tg_transelem_s');
  nextidp=nextval('tg_transelem_s');

  IF (typzestawu IN (3)) THEN
   PERFORM gm.blocktriggerfunction('MARKTEASSAFEFORCHANGE'::gm.triggerfunction,1,nextidm);
  END IF;

  IF (rd.tel_skojzestaw IS NOT NULL) THEN
  
   rd.tel_skojzestaw=(SELECT newteidm FROM rozmiarowkamap WHERE oldteid=rd.tel_skojzestaw);
   IF (rd.tel_skojzestaw IS NULL) THEN
	RAISE EXCEPTION 'Blad przy robieniu korekty rozmiarowki minusowej';
   END IF;
   
   IF (typzestawu IN (3)) THEN
	--------------------------------------------------------------------------------------
	---Zablokuj zmiane sposobu pakowania na zrodlowym transelemie
    PERFORM gm.blocktriggerfunction('MARKTEASSAFEFORCHANGE'::gm.triggerfunction,1,rd.id);
	UPDATE tg_transelem SET tel_new2flaga=tel_new2flaga|(1<<25) WHERE (tel_new2flaga&(1<<25)=0) AND tel_idelem=rd.id;
    PERFORM gm.blocktriggerfunction('MARKTEASSAFEFORCHANGE'::gm.triggerfunction,-1,rd.id);
	--------------------------------------------------------------------------------------
    rd.tel_new2flaga=rd.tel_new2flaga|(1<<25);
   END IF;
  ELSE
   RAISE NOTICE 'DOdaje do mapy % %->%',rd.tel_idelem,nextidm,nextidp;
   INSERT INTO rozmiarowkamap(oldteid,newteidm,newteidp) VALUES (rd.id,nextidm,nextidp);
   INSERT INTO rozmiarowkamap(oldteid,newteidm,newteidp) SELECT rd.tel_idelem,nextidm,nextidp WHERE (SELECT 1 FROM rozmiarowkamap WHERE oldteid=rd.tel_idelem) IS NULL;
  END IF;
  
  INSERT INTO tg_transelem
   (
    tel_idelem,
    ttm_idtowmag,tr_idtrans,tel_nazwa,tel_stvat,tel_clo,ttw_idtowaru,tel_flaga,tel_ilosc,tel_iloscpotr,
    tel_cena0,tel_cenawal,tel_cenabwal,tel_walutawal,tel_kurswal,tel_kursdok,tjn_idjedn,tel_iloscop,
    tjn_opakow,tel_grupacen,tel_skojlog,tel_cecha,tel_lp,tel_lpprefix,tel_przelnilosci,tel_przelnopakow,
    tel_newflaga,tel_uwagi,tel_datawazn,tel_skojarzony,tel_iloscpkor,
    p_idpracownika,tel_skojzestaw,opk_idosrodka,tel_rabatdb,a_idakcji,tel_narzut,tel_wnettowal,tel_wartoscclo,
    tel_cenakgodok,tel_new2flaga,tel_dokladnoscflags,
	prt_idpartii,rmp_idsposobu,
	tel_cenanettods,tel_walutads,tel_cenanettoto,tel_walutato,
	tel_procodlvat
   )
  VALUES
   (
    nextidm,
    rd.ttm_idtowmag,_idkor,rd.tel_nazwa,rd.tel_stvat,rd.tel_clo,rd.ttw_idtowaru,rd.tel_flaga&(~maskf),-rd.tel_ilosc,-rd.tel_iloscpotr,
    rd.tel_cena0,rd.tel_cenawal,rd.tel_cenabwal,rd.tel_walutawal,rd.tel_kurswal,rd.tel_kursdok,rd.tjn_idjedn,-rd.tel_iloscop,
    rd.tjn_opakow,rd.tel_grupacen,NULL,rd.tel_cecha,rd.tel_lp,rd.tel_lpprefix,rd.tel_przelnilosci,rd.tel_przelnopakow,
    rd.tel_newflaga,rd.tel_uwagi,rd.tel_datawazn,rd.id,rd.tel_iloscf,
    rd.p_idpracownika,rd.tel_skojzestaw,rd.opk_idosrodka,rd.tel_rabatdb,rd.a_idakcji,-rd.tel_narzut,-rd.tel_wnettowal,-rd.tel_wartoscclo,
    rd.tel_cenakgodok,rd.tel_new2flaga,rd.tel_dokladnoscflags,
	rd.prt_idpartii,rd.rmp_idsposobu,
	rd.tel_cenanettods,rd.tel_walutads,rd.tel_cenanettoto,rd.tel_walutato,
	rd.tel_procodlvat
   );
      
  IF (typzestawu IN (3)) THEN
   PERFORM gm.blocktriggerfunction('MARKTEASSAFEFORCHANGE'::gm.triggerfunction,-1,nextidm);
  END IF;
  
  IF (rd.tel_skojzestaw IS NOT NULL) THEN
   rd.tel_skojzestaw=(SELECT DISTINCT newteidp FROM rozmiarowkamap WHERE newteidm=rd.tel_skojzestaw);
   IF (rd.tel_skojzestaw IS NULL) THEN
	RAISE EXCEPTION 'Blad przy robieniu korekty rozmiarowki minusowej';
   END IF;
  END IF;
   

   IF ((rd.tel_newflaga&(1<<16))=(1<<16)) THEN
    PERFORM gm.createruchkorekty(rd.id,nextidm,-rd.tel_ilosc);
   END IF;
   
  IF (hastex=TRUE) THEN
   PERFORM gm.kdodokcreattex(_idkor,nextidm,rd.id,TRUE);
   rd.tel_new2flaga=(rd.tel_new2flaga&(~3))|1;
  END IF;

  rd.tel_flaga=rd.tel_flaga|65536;
  rd.tel_new2flaga=rd.tel_new2flaga&(~(1<<3));
  rd.tel_new2flaga=rd.tel_new2flaga|(1<<4);
    
  IF (typzestawu IN (3)) THEN
   PERFORM gm.blocktriggerfunction('MARKTEASSAFEFORCHANGE'::gm.triggerfunction,1,nextidp);
  END IF;
  
  INSERT INTO tg_transelem
   (
    tel_idelem,
    ttm_idtowmag,tr_idtrans,tel_nazwa,tel_stvat,tel_clo,ttw_idtowaru,tel_flaga,tel_ilosc,tel_iloscpotr,
    tel_cena0,tel_cenawal,tel_cenabwal,tel_walutawal,tel_kurswal,tel_kursdok,tjn_idjedn,tel_iloscop,
    tjn_opakow,tel_grupacen,tel_skojlog,tel_cecha,tel_lp,tel_lpprefix,tel_przelnilosci,tel_przelnopakow,
    tel_newflaga,tel_uwagi,tel_datawazn,tel_skojarzony,tel_iloscpkor,
    p_idpracownika,tel_skojzestaw,opk_idosrodka,tel_rabatdb,a_idakcji,tel_narzut,tel_wnettowal,tel_wartoscclo,
    tel_cenakgodok,tel_new2flaga,tel_dokladnoscflags,
	prt_idpartii,rmp_idsposobu,
	tel_cenanettods,tel_walutads,tel_cenanettoto,tel_walutato,
	tel_procodlvat
   )
  VALUES
   (
    nextidp,
    rd.ttm_idtowmag,_idkor,rd.tel_nazwa,rd.tel_stvat,rd.tel_clo,rd.ttw_idtowaru,rd.tel_flaga,rd.tel_ilosc,rd.tel_iloscpotr,
    rd.tel_cena0,rd.tel_cenawal,rd.tel_cenabwal,rd.tel_walutawal,rd.tel_kurswal,rd.tel_kursdok,rd.tjn_idjedn,rd.tel_iloscop,
    rd.tjn_opakow,rd.tel_grupacen,NULL,rd.tel_cecha,rd.tel_lp,rd.tel_lpprefix,rd.tel_przelnilosci,rd.tel_przelnopakow,
    rd.tel_newflaga,rd.tel_uwagi,rd.tel_datawazn,rd.id,rd.tel_iloscf,
    rd.p_idpracownika,rd.tel_skojzestaw,rd.opk_idosrodka,rd.tel_rabatdb,rd.a_idakcji,rd.tel_narzut,rd.tel_wnettowal,rd.tel_wartoscclo,
    rd.tel_cenakgodok,rd.tel_new2flaga,rd.tel_dokladnoscflags,
    rd.prt_idpartii,rd.rmp_idsposobu,
	rd.tel_cenanettods,rd.tel_walutads,rd.tel_cenanettoto,rd.tel_walutato,
	rd.tel_procodlvat
   );

  IF (typzestawu IN (3)) THEN
   PERFORM gm.blocktriggerfunction('MARKTEASSAFEFORCHANGE'::gm.triggerfunction,-1,nextidp);
  END IF;
   
  IF ((rd.tel_newflaga&(1<<16))=(1<<16)) THEN
   PERFORM gm.createruchkorekty(rd.id,nextidp,rd.tel_ilosc);
  END IF;
   
  IF (hastex=TRUE) THEN
   PERFORM gm.kdodokcreattex(_idkor,nextidp,rd.id,FALSE);
  END IF;

  ---RAISE NOTICE 'P %',ile_pozycji;

  ile_pozycji=ile_pozycji+1;
 END LOOP;

 SET enable_mergejoin=on;

 /* 
 ----uakutalniamy powiazanie elementow zestawu by odwowylaly sie do zestawu na korektach
 ---- (Nie potrzebujemy bo ustawiamy juz w funkcji)
 UPDATE tg_transelem 
 SET tel_skojzestaw=(SELECT kor.tel_idelem 
                     FROM tg_transelem AS org 
                     JOIN tg_transelem AS kor ON (kor.tel_skojarzony=org.tel_idelem) 
					 LEFT JOIN tg_transelem AS korpop ON (korpop.tel_skojarzony=org.tel_idelem  AND kor.tr_idtrans<>korpop.tr_idtrans) 
					 WHERE kor.tr_idtrans=tg_transelem.tr_idtrans AND 
					       coalesce(korpop.tel_idelem,org.tel_idelem)=tg_transelem.tel_skojzestaw AND 
						   kor.tel_flaga&65536=tg_transelem.tel_flaga&65536 
				     LIMIT 1 OFFSET 0
					) WHERE tel_skojzestaw>0 AND 
					        tr_idtrans=_idkor AND
							(tel_new2flaga>>17)&15 NOT IN (3);
 */							

 PERFORM vat.disableRecalcing(_idtrans,-1);
 PERFORM vat.disableRecalcing(_idkor,-1);
 DROP TABLE rozmiarowkamap;

 RETURN 1;
END;
$_$;
