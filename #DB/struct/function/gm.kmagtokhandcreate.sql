CREATE FUNCTION kmagtokhandcreate(_idtrans integer, _idkor integer, _movekgo boolean, _dlasprzedazy integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
 dsttrans RECORD;
 kfv RECORD;
 fv RECORD;
 wz RECORD;
 ilosc NUMERIC;
 ilosctmp NUMERIC;
 d RECORD;
 ile_pozycji INT:=0;
 ile_wz INT;
 -----------------
 hastex      BOOL:=FALSE;
 maskf INT:=0;
 typzestawu INT:=0;
 idteplus INT;
 idteminus INT;
 newflagamask INT;
 flagamask INT;
BEGIN

 PERFORM vat.disableRecalcing(_idtrans,1);
 PERFORM vat.disableRecalcing(_idkor,1);
 
 SELECT tr_rodzaj,tr_skojarzona,tr_skojlog,tmg_idmagazynu INTO dsttrans FROM tg_transakcje WHERE tr_idtrans=_idkor;

 CREATE TEMPORARY TABLE korektyFV AS SELECT * FROM tg_transelem LIMIT 0 OFFSET 0;
 CREATE TEMPORARY TABLE WZety AS SELECT * FROM tg_transelem LIMIT 0 OFFSET 0;

 CREATE INDEX korektyfv_i1 ON korektyfv (tel_idelem);
 CREATE INDEX wzety_i1 ON korektyfv (tel_idelem);
 
 CREATE TEMPORARY TABLE IF NOT EXISTS rozmiarowkamap (oldteid INT,newteidm INT,newteidp INT);

 --- Wez rekordy pozycji korekty FV
 FOR kfv IN 
  SELECT te.* 
  FROM tg_transelem AS te 
  JOIN tg_towmag AS tm ON (tm.ttm_idtowmag=te.ttm_idtowmag)
  WHERE te.tr_idtrans=_idtrans AND 
        (te.tel_flaga&65536=65536 OR te.tel_skojarzony IS NULL) AND 
		((te.tel_flaga&4=0) OR (((te.tel_new2flaga>>17)&15) IN (3))) AND 
		tm.tmg_idmagazynu=dsttrans.tmg_idmagazynu
  ORDER BY te.tel_idelem
 LOOP

  IF (_movekgo=FALSE) THEN
   kfv.tel_cenakgodok=0;
  END IF;

  IF (kfv.tel_skojarzony IS NULL) THEN
   -- IDTE korekt FV
   ---RAISE NOTICE 'F1 ';
   INSERT INTO korektyFV SELECT * FROM tg_transelem WHERE tel_idelem=kfv.tel_idelem;
   --IDTE WzetDoFV
   --RAISE NOTICE 'F2 ';
   INSERT INTO WZety SELECT * FROM tg_transelem WHERE tel_skojlog=kfv.tel_idelem;
  ELSE
   -- IDTE korekt FV
   ---RAISE NOTICE 'F3 ';
   INSERT INTO korektyFV SELECT * FROM tg_transelem WHERE tel_skojarzony=kfv.tel_skojarzony AND tel_flaga&65536=65536;
   --IDTE WzetDoFV
   ---RAISE NOTICE 'F4 ';
   INSERT INTO WZety SELECT * FROM tg_transelem WHERE tel_skojlog=kfv.tel_skojarzony;
  END IF;


  --IDTE dopisanych korekt
   ---RAISE NOTICE 'F5 ';
  INSERT INTO WZety SELECT te.* FROM korektyFV AS k JOIN tg_transelem AS te ON (te.tel_skojlog=k.tel_idelem) WHERE (te.tel_skojarzony=NULL OR te.tel_flaga&65536=65536);

  --IDTE korektWZ
  ---RAISE NOTICE 'F6 ';
  ----EXECUTE 'INSERT INTO WZety SELECT te.* FROM WZety AS k JOIN tg_transelem AS te ON (te.tel_skojarzony=k.tel_idelem) WHERE te.tel_skojlog=NULL';
  INSERT INTO WZety SELECT te.* FROM tg_transelem AS te WHERE te.tel_skojlog=NULL AND te.tel_skojarzony IN (SELECT tel_idelem FROM WZety);

  --Usun skorygowane podstawowe WZety
  ---RAISE NOTICE 'F7 ';
  DELETE FROM WZety WHERE tel_skojarzony=NULL AND tel_idelem IN (SELECT tel_skojarzony FROM WZety WHERE tel_skojarzony IS NOT NULL);
  ---RAISE NOTICE 'F8 ';
  ---EXECUTE 'DELETE FROM WZety WHERE tel_skojarzony IS NOT NULL AND tel_idelem<>(SELECT tel_idelem FROM WZety WHERE tel_skojarzony IS NOT NULL ORDER BY tel_idelem DESC LIMIT 1 OFFSET 0)';
  DELETE FROM WZety WHERE tel_skojarzony IS NOT NULL AND tel_idelem<>(SELECT w.tel_idelem FROM WZety AS w WHERE w.tel_skojarzony=wzety.tel_skojarzony AND w.tel_skojarzony IS NOT NULL ORDER BY w.tel_idelem DESC LIMIT 1 OFFSET 0);
  DELETE FROM WZety WHERE tel_skojarzony IS NOT NULL AND tel_iloscf=0 AND tel_iloscpkor>0;
  ---RAISE NOTICE 'F9 ';

  ile_wz=0;
  ilosc=-_dlasprzedazy*kfv.tel_iloscwyd;
  IF (kfv.tel_skojzestaw IS NULL) AND (gmr.getTypZestawu(kfv.tel_new2flaga) IN (3)) THEN
   ilosc=-_dlasprzedazy*(SELECT sum(tel_iloscwyd) FROM tg_transelem WHERE tel_skojzestaw=kfv.tel_idelem);
  END IF;
  FOR wz IN SELECT * FROM WZety ORDER BY tel_idelem DESC
  LOOP
   ---RAISE NOTICE 'Cos znalazlem % ',wz.tel_idelem;
   ile_wz=ile_wz+1;
   
   flagamask=(1|2|4|8|32|64|128|2048|131072|(1<<31));
   newflagamask=(7|(1<<23));   
   typzestawu=gmr.getTypZestawu(wz.tel_new2flaga);
     
   idteminus=nextval('tg_transelem_s');
   idteplus=nextval('tg_transelem_s');
   
   IF (typzestawu IN (3)) THEN
    PERFORM gm.blocktriggerfunction('MARKTEASSAFEFORCHANGE'::gm.triggerfunction,1,idteminus);    
    IF (wz.tel_skojzestaw IS NOT NULL) THEN
	 --------------------------------------------------------------------------------------
	 ---Zablokuj zmiane sposobu pakowania na zrodlowym transelemie
     PERFORM gm.blocktriggerfunction('MARKTEASSAFEFORCHANGE'::gm.triggerfunction,1,COALESCE(wz.tel_skojarzony,wz.tel_idelem));
	 UPDATE tg_transelem SET tel_new2flaga=tel_new2flaga|(1<<25) WHERE (tel_new2flaga&(1<<25)=0) AND tel_idelem=COALESCE(wz.tel_skojarzony,wz.tel_idelem);
     PERFORM gm.blocktriggerfunction('MARKTEASSAFEFORCHANGE'::gm.triggerfunction,-1,COALESCE(wz.tel_skojarzony,wz.tel_idelem));
	 --------------------------------------------------------------------------------------
     wz.tel_skojzestaw=(SELECT newteidm FROM rozmiarowkamap WHERE oldteid=wz.tel_skojzestaw);
	 IF (wz.tel_skojzestaw IS NULL) THEN
 	 RAISE EXCEPTION 'Blad przy robieniu korekty rozmiarowki minusowej';
	 END IF;
    ELSE
     INSERT INTO rozmiarowkamap(oldteid,newteidm,newteidp) VALUES (wz.tel_idelem,idteminus,idteplus);
    END IF;
    wz.tel_new2flaga=wz.tel_new2flaga|(1<<25);	
	flagamask=flagamask|1024;
	newflagamask=newflagamask|256;
   ELSE
    wz.tel_skojzestaw=NULL;
	wz.tel_przelnopakow=1000;
   END IF;
   
   wz.tel_flaga=wz.tel_flaga&flagamask;
   wz.tel_newflaga=(wz.tel_newflaga&newflagamask);
   wz.tel_new2flaga=wz.tel_new2flaga|(1<<3);
   maskf=maskf|131072;
   ---wz.tel_iloscpotr=0;
   
   hastex=((wz.tel_new2flaga&3)<>0);
   IF (hastex=TRUE) THEN
    wz.tel_new2flaga=(wz.tel_new2flaga&(~3))|1;
	IF (_dlasprzedazy!=1) THEN
	 RAISE EXCEPTION 'Korekty na TEEX mozna robic tylko po stronie przychodowej!';
	END IF;
   END IF;


   INSERT INTO tg_transelem
   (
    tel_idelem,
    ttm_idtowmag,tr_idtrans,tel_nazwa,tel_stvat,tel_clo,ttw_idtowaru,tel_flaga,tel_ilosc,tel_iloscpotr,
    tel_cena0,tel_cenawal,tel_cenabwal,tel_walutawal,tel_kurswal,tjn_idjedn,tel_kursdok,
    tjn_opakow,tel_grupacen,tel_skojlog,tel_cecha,tel_lp,tel_przelnilosci,
    tel_newflaga,tel_uwagi,tel_datawazn,tel_datazam,tel_skojarzony,tel_iloscpkor,
    p_idpracownika,a_idakcji,tel_wnettowal,tel_cenakgodok,tel_dokladnoscflags,
	tel_new2flaga,prt_idpartii,
	tel_skojzestaw,rmp_idsposobu,tel_przelnopakow,
	tel_cenanettods,tel_walutads,tel_cenanettoto,tel_walutato
   )
   VALUES
   (
    idteminus,
    wz.ttm_idtowmag,_idkor,wz.tel_nazwa,wz.tel_stvat,wz.tel_clo,wz.ttw_idtowaru,wz.tel_flaga&(~maskf),-wz.tel_ilosc,-wz.tel_iloscpotr,
    wz.tel_cena0,wz.tel_cenawal,wz.tel_cenabwal,wz.tel_walutawal,wz.tel_kurswal,wz.tjn_idjedn,wz.tel_kursdok,
    wz.tjn_opakow,wz.tel_grupacen,kfv.tel_idelem,wz.tel_cecha,wz.tel_lp,wz.tel_przelnilosci,
    wz.tel_newflaga,wz.tel_uwagi,wz.tel_datawazn,wz.tel_datazam,COALESCE(wz.tel_skojarzony,wz.tel_idelem),0,
    kfv.p_idpracownika,kfv.a_idakcji,-wz.tel_wnettowal,wz.tel_cenakgodok,wz.tel_dokladnoscflags,
	wz.tel_new2flaga,wz.prt_idpartii,
	wz.tel_skojzestaw,wz.rmp_idsposobu,wz.tel_przelnopakow,
	wz.tel_cenanettods,wz.tel_walutads,wz.tel_cenanettoto,wz.tel_walutato
   );

   RAISE NOTICE 'Jest kurs % % %',wz.tel_walutawal,wz.tel_kurswal,(SELECT tel_kurswal FROM tg_transelem WHERE tel_idelem=idteminus);   
   
   IF (typzestawu IN (3)) THEN
    PERFORM gm.blocktriggerfunction('MARKTEASSAFEFORCHANGE'::gm.triggerfunction,-1,idteminus);
   END IF;
   
   IF (hastex=TRUE) THEN
    PERFORM gm.kdodokcreattex(_idkor,idteminus,COALESCE(wz.tel_skojarzony,wz.tel_idelem),TRUE,FALSE);
    wz.tel_new2flaga=(wz.tel_new2flaga&(~3))|2;
   END IF;
      

   wz.tel_flaga=wz.tel_flaga|65536;
   wz.tel_new2flaga=wz.tel_new2flaga&(~(1<<3));
   ilosctmp=ilosc;
   ilosc=0;
   ilosctmp=(wz.tel_iloscf+ilosctmp);
   IF (ilosctmp<0) THEN
    ilosc=ilosctmp;
    ilosctmp=0;
   END IF;

   IF (typzestawu IN (3)) THEN
    PERFORM gm.blocktriggerfunction('MARKTEASSAFEFORCHANGE'::gm.triggerfunction,1,idteplus);
    IF (wz.tel_skojzestaw IS NOT NULL) THEN
     wz.tel_skojzestaw=(SELECT newteidp FROM rozmiarowkamap WHERE newteidm=wz.tel_skojzestaw);
	 IF (wz.tel_skojzestaw IS NULL) THEN
 	  RAISE EXCEPTION 'Blad przy robieniu korekty rozmiarowki minusowej';
	 END IF;
    END IF;
   END IF;
         
   INSERT INTO tg_transelem
   (
    tel_idelem,
    ttm_idtowmag,tr_idtrans,tel_nazwa,tel_stvat,tel_clo,ttw_idtowaru,tel_flaga,tel_ilosc,tel_iloscpotr,
    tel_cena0,tel_cenawal,tel_cenabwal,tel_walutawal,tel_kurswal,tjn_idjedn,
    tjn_opakow,tel_grupacen,tel_skojlog,tel_cecha,tel_lp,tel_przelnilosci,
    tel_newflaga,tel_uwagi,tel_datawazn,tel_datazam,tel_skojarzony,tel_iloscpkor,
    p_idpracownika,a_idakcji,tel_wnettowal,tel_cenakgodok,tel_dokladnoscflags,
   	tel_new2flaga,prt_idpartii,
	tel_skojzestaw,rmp_idsposobu,tel_przelnopakow,
	tel_cenanettods,tel_walutads,tel_cenanettoto,tel_walutato
   )
   VALUES
   (
    idteplus,
    wz.ttm_idtowmag,_idkor,wz.tel_nazwa,wz.tel_stvat,wz.tel_clo,wz.ttw_idtowaru,wz.tel_flaga,1000*ilosctmp/wz.tel_przelnilosci-wz.tel_iloscpotr,wz.tel_iloscpotr,
    kfv.tel_cena0,kfv.tel_cenawal,kfv.tel_cenabwal,kfv.tel_walutawal,wz.tel_kurswal,wz.tjn_idjedn,
    wz.tjn_opakow,wz.tel_grupacen,kfv.tel_idelem,wz.tel_cecha,wz.tel_lp,wz.tel_przelnilosci,
    wz.tel_newflaga,wz.tel_uwagi,wz.tel_datawazn,wz.tel_datazam,COALESCE(wz.tel_skojarzony,wz.tel_idelem),wz.tel_iloscf,
    kfv.p_idpracownika,kfv.a_idakcji,kfv.tel_wnettowal,wz.tel_cenakgodok,wz.tel_dokladnoscflags,
	wz.tel_new2flaga,wz.prt_idpartii,
	wz.tel_skojzestaw,wz.rmp_idsposobu,wz.tel_przelnopakow,
    wz.tel_cenanettods,wz.tel_walutads,wz.tel_cenanettoto,wz.tel_walutato
   );
   
   IF (typzestawu IN (3)) THEN
    PERFORM gm.blocktriggerfunction('MARKTEASSAFEFORCHANGE'::gm.triggerfunction,-1,idteplus);
   END IF;
   
   IF (hastex=TRUE) THEN
    PERFORM gm.kdodokcreattex(_idkor,idteplus,COALESCE(wz.tel_skojarzony,wz.tel_idelem),FALSE,TRUE);
   END IF;
   
  END LOOP;
  
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  
  IF (ile_wz=0) THEN
   kfv.tel_flaga=kfv.tel_flaga&(1|2|4|8|32|64|128|2048|131072|(1<<31));
   kfv.tel_newflaga=(kfv.tel_newflaga&(4|(1<<23)))|1;
   
   IF (gmr.getTypZestawu(kfv.tel_new2flaga) IN (3)) THEN
    RAISE EXCEPTION 'Nie mozna dodawac nowych pozycji';
   END IF;
   

   INSERT INTO tg_transelem
   (
    ttm_idtowmag,tr_idtrans,tel_nazwa,tel_stvat,tel_clo,ttw_idtowaru,tel_flaga,tel_ilosc,tel_iloscpotr,
    tel_cena0,tel_cenawal,tel_cenabwal,tel_walutawal,tel_kurswal,tjn_idjedn,
    tjn_opakow,tel_grupacen,tel_skojlog,tel_cecha,tel_lp,tel_przelnilosci,
    tel_newflaga,tel_uwagi,tel_datawazn,tel_datazam,tel_skojarzony,tel_iloscpkor,
    p_idpracownika,a_idakcji,tel_cenakgodok,tel_dokladnoscflags,
	tel_new2flaga,prt_idpartii
   )
   VALUES
   (
    kfv.ttm_idtowmag,_idkor,kfv.tel_nazwa,kfv.tel_stvat,kfv.tel_clo,kfv.ttw_idtowaru,kfv.tel_flaga,(1000*kfv.tel_iloscwyd)/kfv.tel_przelnilosci,kfv.tel_iloscpotr,
    kfv.tel_cena0,kfv.tel_cenawal,kfv.tel_cenabwal,kfv.tel_walutawal,kfv.tel_kurswal,kfv.tjn_idjedn,
    kfv.tjn_opakow,kfv.tel_grupacen,kfv.tel_idelem,kfv.tel_cecha,kfv.tel_lp,kfv.tel_przelnilosci,
    kfv.tel_newflaga,kfv.tel_uwagi,kfv.tel_datawazn,kfv.tel_datazam,NULL,0,
    kfv.p_idpracownika,kfv.a_idakcji,kfv.tel_cenakgodok,kfv.tel_dokladnoscflags,
	kfv.tel_new2flaga,kfv.prt_idpartii
   );
   
  END IF;

  DELETE FROM WZety;
  DELETE FROM korektyFV;


  ile_pozycji=ile_pozycji+1;
 END LOOP; --- OF wz_loop

 DROP TABLE WZety;
 DROP TABLE korektyFV;
 DROP TABLE rozmiarowkamap;

 PERFORM vat.disableRecalcing(_idtrans,-1);
 PERFORM vat.disableRecalcing(_idkor,-1);
 
 RETURN ile_pozycji;
END;
$$;
