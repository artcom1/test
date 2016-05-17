CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 doupdskoj BOOL:=FALSE;
 doupdskojwyn BOOL:=FALSE;
 cnt INT;
 zlecenie_old INT;
 zlecenie_new INT;
 _wynik INT;
  rozliczenie_ko RECORD;
 przeliczamy_zl_old bool:=false;
 przeliczamy_zl_new bool:=false;

 dzadluzenieo NUMERIC:=0;
 dzadluzenien NUMERIC:=0;
 fm_idind INT:=0;
 
 niezafaktwz_old NUMERIC:=0;
 niezafaktwz NUMERIC:=0;
 niezafaktwz_kwz NUMERIC:=0;
 rozliczajNOcfg TEXT;
 rozliczajNOold BOOL;
 rozliczajNOnew BOOL;
 rec RECORD;
BEGIN
 rozliczajNOold := false;
 rozliczajNOnew := false;
 IF ((TG_OP='UPDATE') OR (TG_OP='DELETE')) THEN
  IF (OLD.zl_idzlecenia>0) THEN
   SELECT zl_typ INTO rec FROM tg_zlecenia WHERE zl_idzlecenia=OLD.zl_idzlecenia;
   rozliczajNOcfg :=  OLD.tr_flaga & (1 << 22);
   rozliczajNOold := (rozliczajNOcfg = '1');
  END IF;
 END IF;
 IF ((TG_OP='UPDATE') OR (TG_OP='INSERT')) THEN
  IF (NEW.zl_idzlecenia>0) THEN
   SELECT zl_typ INTO rec FROM tg_zlecenia WHERE zl_idzlecenia=NEW.zl_idzlecenia;
   rozliczajNOcfg :=  NEW.tr_flaga & (1 << 22);
   rozliczajNOnew := (rozliczajNOcfg = '1');
  END IF;
 END IF; 

 IF (TG_OP='UPDATE') THEN

  IF (NEW.k_idklienta<>OLD.k_idklienta) OR (NEW.tr_oidklienta<>OLD.tr_oidklienta) OR (date(NEW.tr_datasprzedaz)<>date(OLD.tr_datasprzedaz)) THEN
   IF ((NEW.tr_flaga&2)<>0) THEN
    UPDATE tg_transakcje SET k_idklienta=NEW.k_idklienta,tr_oidklienta=NEW.tr_oidklienta,tr_datasprzedaz=NEW.tr_datasprzedaz,tr_datawystaw=NEW.tr_datawystaw WHERE tr_rodzaj=60 AND tr_skojarzona=NEW.tr_idtrans;
   END IF;
   UPDATE tg_transelem SET tel_idklienta=NEW.k_idklienta,tel_oidklienta=NEW.tr_oidklienta WHERE tr_idtrans=NEW.tr_idtrans AND (tel_idklienta<>NEW.k_idklienta OR tel_oidklienta<>NEW.tr_oidklienta);
   UPDATE tg_ruchy SET k_idklienta=NEW.k_idklienta,rc_data=NEW.tr_datasprzedaz WHERE tr_idtrans=NEW.tr_idtrans AND (tg_ruchy.k_idklienta<>NEW.k_idklienta OR rc_data<>date(NEW.tr_datasprzedaz)) AND NOT isRezerwacja(rc_flaga);
   UPDATE tg_ruchy SET k_idklienta=NEW.tr_oidklienta WHERE tr_idtrans=NEW.tr_idtrans AND (tg_ruchy.k_idklienta<>NEW.tr_oidklienta) AND isRezerwacja(rc_flaga);
  END IF;

  IF (COALESCE(NEW.tr_skojlog,0)<>COALESCE(OLD.tr_skojlog,0)) THEN
   doupdskoj=TRUE;
   --- Odczep skojarzone elementy
   IF NOT OLD.tr_skojlog=NULL THEN
    UPDATE tg_transelem SET tel_skojlog=NULL WHERE tr_idtrans=NEW.tr_idtrans AND NOT tel_skojlog=NULL;
   END IF;
  END IF;

  IF (COALESCE(NEW.tr_skojwyn,0)<>COALESCE(OLD.tr_skojwyn,0)) THEN
   doupdskojwyn=TRUE;
  END IF;

  IF (NEW.k_idklienta<>OLD.k_idklienta OR 
      (NEW.tr_oidklienta<>OLD.tr_oidklienta AND ((NEW.tr_zamknieta&(1<<23))=0) OR
      (NEW.tr_zamknieta&(1<<23))<>(OLD.tr_zamknieta&(1<<23))
     ) AND 
     (
      (NEW.tr_flaga&64)<>0) OR
      (NEW.tr_skojlog IS NOT NULL)
     ) THEN
   -- Updateuj informacje o skojarzonych klientach
   UPDATE tg_transakcje SET
    k_idklienta=NEW.k_idklienta,
    tr_oidklienta=(CASE WHEN (NEW.tr_zamknieta&(1<<23))=0 THEN NEW.tr_oidklienta ELSE tr_oidklienta END),
    tr_knazwa=NEW.tr_knazwa,
    tr_kadres=NEW.tr_kadres,
    tr_nip=NEW.tr_nip,
    tr_kmiasto=NEW.tr_kmiasto,
    tr_kkodpocz=NEW.tr_kkodpocz,
    tr_onazwa=(CASE WHEN (NEW.tr_zamknieta&(1<<23))=0 THEN NEW.tr_onazwa ELSE tr_onazwa END),
    tr_oadres=(CASE WHEN (NEW.tr_zamknieta&(1<<23))=0 THEN NEW.tr_oadres ELSE tr_oadres END),
    tr_onip=(CASE WHEN (NEW.tr_zamknieta&(1<<23))=0 THEN NEW.tr_onip ELSE tr_onip END),
    tr_omiasto=(CASE WHEN (NEW.tr_zamknieta&(1<<23))=0 THEN NEW.tr_omiasto ELSE tr_omiasto END),
    tr_okodpocz=(CASE WHEN (NEW.tr_zamknieta&(1<<23))=0 THEN NEW.tr_okodpocz ELSE tr_okodpocz END)
   WHERE tr_skojlog=NEW.tr_idtrans OR
         (tr_skojarzona=NEW.tr_idtrans AND NEW.tr_skojlog IS NOT NULL AND ((tr_zamknieta&4)=4));
  END IF;

  IF (NEW.k_idklienta<>OLD.k_idklienta OR NEW.tr_oidklienta<>OLD.tr_oidklienta AND (NEW.tr_flaga&(1<<25))<>0) THEN
   -- Updateuj informacje o skojarzonych klientach
   UPDATE tg_transakcje SET
    k_idklienta=NEW.k_idklienta,
    tr_oidklienta=NEW.tr_oidklienta,
    tr_knazwa=NEW.tr_knazwa,
    tr_kadres=NEW.tr_kadres,
    tr_nip=NEW.tr_nip,
    tr_kmiasto=NEW.tr_kmiasto,
    tr_kkodpocz=NEW.tr_kkodpocz,
    tr_onazwa=NEW.tr_onazwa,
    tr_oadres=NEW.tr_oadres,
    tr_onip=NEW.tr_onip,
    tr_omiasto=NEW.tr_omiasto,
    tr_okodpocz=NEW.tr_okodpocz
   WHERE tr_skojwyn=NEW.tr_idtrans;
  END IF;

 END IF;

 IF (TG_OP='DELETE') THEN
  IF NOT (OLD.tr_skojlog=NULL) THEN
   doupdskoj=TRUE;
  END IF;
  IF NOT (OLD.tr_skojwyn=NULL) THEN
   doupdskojwyn=TRUE;
  END IF;
 END IF;

 IF (doupdskoj) THEN
  --- Jesli dokument nie ma juz skojarzen to wykasuj informacje o tym (bit 64)
  IF NOT (OLD.tr_skojlog=NULL) THEN
   cnt=(SELECT count(*) FROM tg_transakcje WHERE tr_skojlog=OLD.tr_skojlog AND tr_idtrans<>OLD.tr_idtrans);
   IF (cnt=0) THEN
    UPDATE tg_transakcje SET tr_flaga=tr_flaga&(~64) WHERE tr_idtrans=OLD.tr_skojlog;
   END IF;
  END IF;
  --- Operacja opdate - wprowadz informacje o tym ze dokument jest skojarzony
  --- Nie wykonuje sie to zapytanie za kazdym razem gdyz pilnuje tego warunek doupdskoj
  IF (TG_OP='UPDATE') THEN
   IF NOT (NEW.tr_skojlog=NULL) THEN
    UPDATE tg_transakcje SET tr_flaga=tr_flaga|64 WHERE tr_idtrans=NEW.tr_skojlog AND (tr_flaga&64)=0;
   END IF;
  END IF;
 END IF;


 IF (doupdskojwyn) THEN
  IF NOT (OLD.tr_skojwyn=NULL) THEN
   cnt=(SELECT count(*) FROM tg_transakcje WHERE tr_skojwyn=OLD.tr_skojwyn AND tr_idtrans<>OLD.tr_idtrans);
   IF (cnt=0) THEN
    UPDATE tg_transakcje SET tr_flaga=tr_flaga&(~(1<<25)) WHERE tr_idtrans=OLD.tr_skojwyn;
   END IF;
  END IF;
  IF (TG_OP='UPDATE') THEN
   IF NOT (NEW.tr_skojwyn=NULL) THEN
    UPDATE tg_transakcje SET tr_flaga=tr_flaga|(1<<25) WHERE tr_idtrans=NEW.tr_skojwyn AND (tr_flaga&(1<<25))=0;
   END IF;
  END IF;
 END IF;


 ---dla pzamow zamknietych gdy zmieniamy podczepiamy lub zmieniamy zlecenie
 IF (TG_OP='UPDATE') THEN
  IF ( (nullZero(NEW.zl_idzlecenia)>0 OR nullZero(OLD.zl_idzlecenia)>0) AND (NEW.tr_zamknieta&1::int2)=1 AND OLD.tr_rodzaj=30) THEN
   zlecenie_old=OLD.zl_idzlecenia;
   zlecenie_new=NEW.zl_idzlecenia;
   PERFORM PrzeliczPzamDoZlecenia(NEW.tr_idtrans,zlecenie_new, zlecenie_old);
  END IF;
 END IF;
 
 IF (TG_OP='DELETE') THEN
  IF( nullZero(OLD.zl_idzlecenia)>0 AND (OLD.tr_zamknieta&1::int2)=1 AND OLD.tr_rodzaj=30) THEN
    PERFORM PrzeliczPzamDoZlecenia(OLD.tr_idtrans,NULL,OLD.zl_idzlecenia);
  END IF;
 END IF;
---koniec czesci dla zlecen


 ---czesc pod aktualizacje backorderow (daty, zlecenie)
 IF (TG_OP='UPDATE') THEN
  IF (NEW.tr_zamknieta&1=0 AND 
      NEW.tr_flaga&(128+512)=128 AND ---- Magazynowy przychod
	  NEW.tr_datasprzedaz<>OLD.tr_datasprzedaz
	 ) THEN
   --uaktualniamy na backorderach plusowych date (PW, PZ)
   _wynik=(SELECT sum(i) FROM (
           SELECT gm.dodajBackOrderFull(tel_idelem,ttm_idtowmag,tel_iloscf,NOT TEisRozchod(tel_newflaga),2,
		                               ((tel_flaga&(4096+256)=256) AND NOT TEisUsluga(tel_flaga)),tr_idtrans,FALSE,
									   NEW.tr_datasprzedaz,NEW.zl_idzlecenia,NULL,NULL,NULL,tel_new2flaga
									   ) AS i 
           FROM tg_transelem WHERE tr_idtrans=NEW.tr_idtrans AND (tel_newflaga&1)=1 AND (tel_newflaga&4)=0 AND (tel_flaga&1024)=0 AND tel_sprzedaz=0
		  ) AS t);
  END IF;
  IF (NEW.tr_flaga&(128+256+512)=512 AND --- Niemagazynowy, niehandlowy rozchod
      NEW.tr_datawystaw<>OLD.tr_datawystaw
	 ) THEN
   --uaktualniamy na backorderach minusowych date tam gdzie potrzeba (PF)
   _wynik=(SELECT sum(i) FROM (
           SELECT gm.dodajBackOrderFull(tel_idelem,ttm_idtowmag,tel_iloscf,NOT TEisRozchod(tel_newflaga),2, 
		                               ((tel_flaga&(4096+256)=256) AND NOT TEisUsluga(tel_flaga)),tr_idtrans,FALSE,
									   NEW.tr_datawystaw,NEW.zl_idzlecenia,NULL,NULL,NULL,tel_new2flaga
									   ) AS i 
           FROM tg_transelem WHERE tr_idtrans=NEW.tr_idtrans AND tel_flaga&1024=0  AND (tel_flaga&524288)=524288 AND tel_datazam IS NULL 
		  ) AS t);
  END IF;

  IF (NullZero(OLD.zl_idzlecenia)<>NullZero(NEW.zl_idzlecenia)) THEN
   ---zmienilo sie zlecenie na backorderach odnosnie tego dokumentu zmieniamy zlecenie
   UPDATE tg_backorder SET zl_idzlecenia=NEW.zl_idzlecenia WHERE tel_idelemsrc IN (SELECT tel_idelem FROM tg_transelem WHERE tr_idtrans=NEW.tr_idtrans);
   UPDATE tg_backorder SET zl_idzlecenia=NEW.zl_idzlecenia WHERE rc_idruchusrc IN (SELECT rc_idruchu FROM tg_ruchy WHERE tr_idtrans=NEW.tr_idtrans);
  END IF;
 END IF;
 ---koniec czesci pod backordery

 ---czesc pod zlecenia tranposrtowe
  IF (TG_OP='UPDATE') THEN
  IF ((NEW.lt_idtransportu<>OLD.lt_idtransportu  OR NEW.lt_idtransportu=NULL) AND OLD.lt_idtransportu>0) THEN
  --zmieniamy zlecenie transportowe lub odczepiamy je od dokumentu, w tym przypadku kasujemy wszelkie rekordy z powiazeniem klienta zlecenia z dokumentem
   DELETE FROM tg_logkltrans WHERE tr_idtrans=NEW.tr_idtrans;
  END IF;
 END IF;
 ---koniec czesci pod zlecenia transportowe

 ---update rozrachunkow


 IF (TG_OP='UPDATE') THEN
  IF (NEW.tr_zamknieta&64=64) OR (NEW.tr_flaga&(1<<26)<>0) THEN
   IF (NEW.wl_idwaluty<>OLD.wl_idwaluty OR NEW.tr_przelicznik<>OLD.tr_przelicznik) THEN
    PERFORM normalizeWalutaRozrachunkow(NEW.tr_idtrans,NULL,NEW.wl_idwaluty,NEW.tr_dozaplaty,NEW.tr_przelicznik,gm.getKierunekRozrachunku(NEW.tr_flaga,NEW.tr_newflaga)<0);
    IF (NEW.tr_flaga&(1<<21)<>0) THEN
     PERFORM normalizeWalutaRozrachunkow(NEW.tr_idtrans,NULL,NEW.wl_idwaluty,NEW.tr_dozaplaty,NEW.tr_przelicznik,gm.getKierunekRozrachunku(NEW.tr_flaga,NEW.tr_newflaga)>0);
    END IF;
   END IF;
  END IF;

  IF ((NEW.tr_zamknieta&(1<<20))=(1<<20)) AND
     (
      (OLD.tr_dozaplaty<>NEW.tr_dozaplaty) OR
      (OLD.tr_vat<>NEW.tr_vat) OR
      (OLD.tr_wartosc<>NEW.tr_wartosc)
     )
  THEN
   PERFORM resyncAlgorytmVatZAL(NEW.tr_idtrans);
  END IF;
 END IF;
 IF (TG_OP<>'DELETE') THEN
  PERFORM gm.resyncRozrachunkiTrans(NEW);
 END IF;
 ---koniec update rozrachunkow

 ----pod system zlecen


 ---pod niezaplacone dokumenty
 IF (TG_OP='UPDATE') THEN
  IF ((NEW.tr_flaga&256=256 AND (gm.getKierunekRozrachunku(NEW.tr_flaga,NEW.tr_newflaga)<0)) OR (rozliczajNOnew AND ((NEW.tr_rodzaj=114) OR (NEW.tr_rodzaj=115)))) THEN
   IF (NEW.zl_idzlecenia>0) THEN
    UPDATE tg_zlecenia SET 
	 zl_nzaplaconedok=NullZero((SELECT sum(round(((tr_dozaplaty-tr_zaplacono)*tr_przelicznik),2)) FROM tg_transakcje AS tr WHERE tr.zl_idzlecenia=tg_zlecenia.zl_idzlecenia AND ((tr_flaga&256=256 AND (gm.getKierunekRozrachunku(tr_flaga,tr_newflaga)<0)) OR (rozliczajNOnew AND ((tr_rodzaj=114) OR (tr_rodzaj=115)))))) 
	WHERE zl_idzlecenia=NEW.zl_idzlecenia;
   END IF;  
   IF (NEW.zl_idzlecenia<>OLD.zl_idzlecenia AND OLD.zl_idzlecenia>0) THEN
    UPDATE tg_zlecenia SET 
	 zl_nzaplaconedok=NullZero((SELECT sum(round(((tr_dozaplaty-tr_zaplacono)*tr_przelicznik),2)) FROM tg_transakcje AS tr WHERE tr.zl_idzlecenia=tg_zlecenia.zl_idzlecenia AND ((tr_flaga&256=256 AND (gm.getKierunekRozrachunku(tr_flaga,tr_newflaga)<0)) OR (rozliczajNOnew AND ((tr_rodzaj=114) OR (tr_rodzaj=115)))))) 
	WHERE zl_idzlecenia=OLD.zl_idzlecenia;
   END IF;
  END IF;
 END IF;

  ---czesc dotyczaca FZ szczegolowych gdzie czesc moze byc na koszty
 IF (TG_OP='UPDATE') THEN
 ---RAISE NOTICE 'Sprawdzam ktore zlecenia przeliczyc2 % - %',OLD.zl_idzlecenia, NEW.zl_idzlecenia;
  IF ((OLD.tr_rodzaj=145 OR  OLD.tr_rodzaj=345) AND OLD.tr_flaga&256=256) THEN
---RAISE NOTICE 'Sprawdzam ktore zlecenia przeliczyc1 % - %',OLD.zl_idzlecenia, NEW.zl_idzlecenia;  
   IF ((OLD.tr_wartosc*OLD.tr_przelicznik)<>(NEW.tr_wartosc*NEW.tr_przelicznik) OR (NEW.tr_flaga&134217728)<>(OLD.tr_flaga&134217728) OR NullZero(NEW.zl_idzlecenia)<>NullZero(OLD.zl_idzlecenia)) THEN 
---RAISE NOTICE 'Sprawdzam ktore zlecenia przeliczyc % - %',OLD.zl_idzlecenia, NEW.zl_idzlecenia;
    IF (NEW.zl_idzlecenia=OLD.zl_idzlecenia AND NEW.zl_idzlecenia>0) THEN
     przeliczamy_zl_new=true;
    ELSE 
     IF (NEW.zl_idzlecenia>0) THEN
      przeliczamy_zl_new=true;
     END IF;
     IF (OLD.zl_idzlecenia>0) THEN
      przeliczamy_zl_old=true;
     END IF;
    END IF;

   END IF;

   IF (przeliczamy_zl_new) THEN
    ---dokumenty FZ i KFZ, tylko dla szczegolowych, uaktualniamy na zleceniu wartosciosc kosztow ze wszystkich dokumentow
    SELECT sum(( CASE WHEN (tr_zamknieta & (128 | (1 << 17))) = 128 THEN tel_brutto-tel_vatb WHEN (tr_zamknieta & (128 | (1 << 17))) = (128 | (1 << 17)) THEN tel_brutto - tel_vatb2 ELSE tel_netto END)*tr_przelicznik) AS netto, sum(( CASE WHEN (tr_zamknieta & 128) = 128 THEN tel_brutto WHEN (tr_zamknieta & (1 << 17)) = (1 << 17) THEN tel_netto + tel_vat2 ELSE tel_netto + tel_vat END)*tr_przelicznik) AS brutto 
INTO rozliczenie_ko 
FROM (
 SELECT tr_idtrans, tr_zamknieta,tr_przelicznik, sum(tel_netto) AS tel_netto, sum(tel_vat) AS tel_vat, sum(tel_vat2) AS tel_vat2, sum(tel_vatb) AS tel_vatb, sum(tel_vatb2) AS tel_vatb2, sum(tel_brutto) AS tel_brutto   
 FROM (
  SELECT tr_idtrans, tr_zamknieta,tr_przelicznik,sum(tel_wnettodok) AS tel_netto, round(vatfromnet(sum(tel_wnettodok), tel_stvat::numeric), 2) AS tel_vat, sum(round(vatfromnet(tel_wnettodok, tel_stvat::numeric), 2)) AS tel_vat2, round(vatfrombrt(sum(round(tel_cenabdok * tel_ilosc, 2)), tel_stvat::numeric), 2) AS tel_vatb,sum(round(vatfrombrt(round(tel_cenabdok * tel_ilosc, 2), tel_stvat::numeric), 2)) AS tel_vatb2, sum(round(tel_cenabdok * tel_ilosc, 2)) AS tel_brutto  
  FROM tg_transelem 
  JOIN tg_transakcje USING (tr_idtrans) 
  WHERE (tel_flaga & 1024) = 0 AND 
        ((tel_flaga&(4+8)!=0 AND 
  tr_rodzaj IN (145,345) AND 
  tr_flaga&256=256
 ) OR 
 tr_rodzaj IN (45,245)
) AND 
tr_flaga&134217728=0 AND 
zl_idzlecenia=NEW.zl_idzlecenia 
  GROUP BY tr_idtrans, tr_zamknieta,tr_przelicznik,tel_stvat
 ) AS t  
 GROUP BY tr_idtrans, tr_zamknieta,tr_przelicznik 
    ) AS tr;

    UPDATE tg_zlecenia SET zl_koszt=round(NullZero(rozliczenie_ko.netto),2),zl_kosztbrt=round(NullZero(rozliczenie_ko.brutto),2) WHERE zl_idzlecenia=NEW.zl_idzlecenia;
   END IF;

   IF (przeliczamy_zl_old) THEN
     ---dokumenty FZ i KFZ, tylko dla szczegolowych, uaktualniamy na zleceniu wartosciosc kosztow ze wszystkich dokumentow
    SELECT sum(( CASE WHEN (tr_zamknieta & (128 | (1 << 17))) = 128 THEN tel_brutto-tel_vatb WHEN (tr_zamknieta & (128 | (1 << 17))) = (128 | (1 << 17)) THEN tel_brutto - tel_vatb2 ELSE tel_netto END)*tr_przelicznik) AS netto, sum(( CASE WHEN (tr_zamknieta & 128) = 128 THEN tel_brutto WHEN (tr_zamknieta & (1 << 17)) = (1 << 17) THEN tel_netto + tel_vat2 ELSE tel_netto + tel_vat END)*tr_przelicznik) AS brutto 
INTO rozliczenie_ko 
FROM (
 SELECT tr_idtrans, tr_zamknieta,tr_przelicznik, sum(tel_netto) AS tel_netto, sum(tel_vat) AS tel_vat, sum(tel_vat2) AS tel_vat2, sum(tel_vatb) AS tel_vatb, sum(tel_vatb2) AS tel_vatb2, sum(tel_brutto) AS tel_brutto  
 FROM (
  SELECT tr_idtrans, tr_zamknieta,tr_przelicznik,sum(tel_wnettodok) AS tel_netto, round(vatfromnet(sum(tel_wnettodok), tel_stvat::numeric), 2) AS tel_vat, sum(round(vatfromnet(tel_wnettodok, tel_stvat::numeric), 2)) AS tel_vat2, round(vatfrombrt(sum(round(tel_cenabdok * tel_ilosc, 2)), tel_stvat::numeric), 2) AS tel_vatb,sum(round(vatfrombrt(round(tel_cenabdok * tel_ilosc, 2), tel_stvat::numeric), 2)) AS tel_vatb2, sum(round(tel_cenabdok * tel_ilosc, 2)) AS tel_brutto  
  FROM tg_transelem 
  JOIN tg_transakcje USING (tr_idtrans) 
  WHERE (tel_flaga & 1024) = 0 AND 
        ((tel_flaga&(4+8)!=0 AND 
  tr_rodzaj IN (145,345) AND 
  tr_flaga&256=256
 ) OR 
 tr_rodzaj IN (45,245)
) AND 
tr_flaga&134217728=0 AND 
zl_idzlecenia=OLD.zl_idzlecenia 
GROUP BY tr_idtrans, tr_zamknieta,tr_przelicznik,tel_stvat
 ) AS t 
 GROUP BY tr_idtrans, tr_zamknieta,tr_przelicznik 
) AS tr;
 
    UPDATE tg_zlecenia SET zl_koszt=round(NullZero(rozliczenie_ko.netto),2),zl_kosztbrt=round(NullZero(rozliczenie_ko.brutto),2) WHERE zl_idzlecenia=OLD.zl_idzlecenia;
   END IF;
  END IF;
 END IF;
 IF (TG_OP='DELETE') THEN
  IF ((OLD.tr_rodzaj=145 OR  OLD.tr_rodzaj=345) AND OLD.tr_flaga&256=256 AND OLD.zl_idzlecenia>0) THEN
   ---dokumenty FZ i KFZ, tylko dla szczegolowych, uaktualniamy na zleceniu wartosciosc kosztow ze wszystkich dokumentow
   SELECT ( CASE WHEN (tr_zamknieta & (128 | (1 << 17))) = 128 THEN tel_brutto-tel_vatb WHEN (tr_zamknieta & (128 | (1 << 17))) = (128 | (1 << 17)) THEN tel_brutto - tel_vatb2 ELSE tel_netto END)*tr_przelicznik AS netto, ( CASE WHEN (tr_zamknieta & 128) = 128 THEN tel_brutto WHEN (tr_zamknieta & (1 << 17)) = (1 << 17) THEN tel_netto + tel_vat2 ELSE tel_netto + tel_vat END)*tr_przelicznik AS brutto INTO rozliczenie_ko FROM (SELECT tr_idtrans, tr_zamknieta,tr_przelicznik, sum(tel_netto) AS tel_netto, sum(tel_vat) AS tel_vat, sum(tel_vat2) AS tel_vat2, sum(tel_vatb) AS tel_vatb, sum(tel_vatb2) AS tel_vatb2, sum(tel_brutto) AS tel_brutto  FROM (SELECT tr_idtrans, tr_zamknieta,tr_przelicznik,sum(tel_wnettodok) AS tel_netto, round(vatfromnet(sum(tel_wnettodok), tel_stvat::numeric), 2) AS tel_vat, sum(round(vatfromnet(tel_wnettodok, tel_stvat::numeric), 2)) AS tel_vat2, round(vatfrombrt(sum(round(tel_cenabdok * tel_ilosc, 2)), tel_stvat::numeric), 2) AS tel_vatb,sum(round(vatfrombrt(round(tel_cenabdok * tel_ilosc, 2), tel_stvat::numeric), 2)) AS tel_vatb2, sum(round(tel_cenabdok * tel_ilosc, 2)) AS tel_brutto  FROM tg_transelem JOIN tg_transakcje USING (tr_idtrans) WHERE (tel_flaga & 1024) = 0 AND ((tel_flaga&(4+8)!=0 AND tr_rodzaj IN (145,345) AND tr_flaga&256=256) OR tr_rodzaj IN (45,245)) AND tr_flaga&134217728=0 AND zl_idzlecenia=OLD.zl_idzlecenia AND tr_idtrans!=OLD.tr_idtrans GROUP BY tr_idtrans, tr_zamknieta,tr_przelicznik,tel_stvat) AS t GROUP BY tr_idtrans, tr_zamknieta,tr_przelicznik ) AS tr;
 
   UPDATE tg_zlecenia SET zl_koszt=round(NullZero(rozliczenie_ko.netto),2),zl_kosztbrt=round(NullZero(rozliczenie_ko.brutto),2) WHERE zl_idzlecenia=OLD.zl_idzlecenia;
  END IF;
 END IF;
 

  ---dla rozliczen delegacji 
 IF (TG_OP='DELETE') THEN
  UPDATE tg_rozliczdelegacja SET tr_idtrans=NULL WHERE tr_idtrans=OLD.tr_idtrans;
 END IF;
---koniec czesci dla rozliczen delegacji



 ------------------------------------------------------
 ---pod liczenie zobowiazan dla handlowca
 ------------------------------------------------------
 IF (TG_OP='INSERT') THEN
  IF (NEW.tr_flaga&256=256 AND (gm.getKierunekRozrachunku(NEW.tr_flaga,NEW.tr_newflaga)<0) AND NEW.tr_zamknieta&64=64) THEN
   dzadluzenien=round(((NEW.tr_dozaplaty-NEW.tr_zaplacono)*NEW.tr_przelicznik),2);
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NEW.tr_flaga&256=256 AND (gm.getKierunekRozrachunku(NEW.tr_flaga,NEW.tr_newflaga)<0) AND NEW.tr_zamknieta&64=64) THEN
   IF (round(((NEW.tr_dozaplaty-NEW.tr_zaplacono)*NEW.tr_przelicznik),2)!=round(((OLD.tr_dozaplaty-OLD.tr_zaplacono)*OLD.tr_przelicznik),2)) THEN
    dzadluzenien=round(((NEW.tr_dozaplaty-NEW.tr_zaplacono)*NEW.tr_przelicznik),2)-round(((OLD.tr_dozaplaty-OLD.tr_zaplacono)*OLD.tr_przelicznik),2);
   END IF;
   IF (NEW.tr_zaliczonedla!=OLD.tr_zaliczonedla) THEN
    dzadluzenien=round(((NEW.tr_dozaplaty-NEW.tr_zaplacono)*NEW.tr_przelicznik),2);
    dzadluzenieo=round(((OLD.tr_dozaplaty-OLD.tr_zaplacono)*OLD.tr_przelicznik),2);
   END IF;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  IF (OLD.tr_flaga&256=256 AND (gm.getKierunekRozrachunku(OLD.tr_flaga,OLD.tr_newflaga)<0) AND OLD.tr_zamknieta&64=64) THEN
   dzadluzenieo=round(((OLD.tr_dozaplaty-OLD.tr_zaplacono)*OLD.tr_przelicznik),2);
  END IF;
 END IF;

 IF (dzadluzenien!=0) THEN
  fm_idind=(SELECT fm_idindextab FROM tb_firma  WHERE fm_index=NEW.fm_idcentrali);
  UPDATE tb_pracownicy SET p_zadluzenie[fm_idind]=NullZero(p_zadluzenie[fm_idind])+dzadluzenien WHERE p_idpracownika=NEW.tr_zaliczonedla;
 END IF;

 IF (dzadluzenieo!=0) THEN
  fm_idind=(SELECT fm_idindextab FROM tb_firma  WHERE fm_index=OLD.fm_idcentrali);
  UPDATE tb_pracownicy SET p_zadluzenie[fm_idind]=NullZero(p_zadluzenie[fm_idind])-dzadluzenieo WHERE p_idpracownika=OLD.tr_zaliczonedla;
 END IF;
 ------------------------------------------------------
 ---KONIEC pod liczenie zobowiazan dla handlowca
 ------------------------------------------------------


 ------------------------------------------------------
 ---pod liczenie niezafakt dla klienta
 ------------------------------------------------------
 IF (OLD.tr_rodzaj IN (2,12)) THEN   
 
  cnt=0;
  IF (OLD.tr_rodzaj=2) THEN
   cnt=1;
  ELSE
   cnt=(SELECT COUNT(*) FROM tg_transakcje AS doksrc WHERE doksrc.tr_skojlog IS NULL AND doksrc.tr_idtrans=OLD.tr_skojarzona AND doksrc.tr_rodzaj=2);
  END IF;
  
  IF (cnt>0) THEN  
   ---Pobieranie identyfikatora dla typu tablicowego
   fm_idind=(SELECT fm_idindextab FROM tb_firma  WHERE fm_index=OLD.fm_idcentrali);

   ---Delete tylko odejmuje
   IF (TG_OP='DELETE' AND (COALESCE(OLD.tr_skojlog,0)=0)) THEN
    niezafaktwz=round(((OLD.tr_dozaplaty-OLD.tr_zaplacono)*OLD.tr_przelicznik),2);
    UPDATE tb_klient SET k_niezafaktwz[fm_idind]=(NullZero(k_niezafaktwz[fm_idind])-niezafaktwz) WHERE k_idklienta=OLD.k_idklienta;   
   END IF; --- delete
  
   ---Update sprawdzam kilka rzeczy
   IF (TG_OP='UPDATE') THEN
    niezafaktwz_old=round(((OLD.tr_dozaplaty-OLD.tr_zaplacono)*OLD.tr_przelicznik),2);
    niezafaktwz=round(((NEW.tr_dozaplaty-NEW.tr_zaplacono)*NEW.tr_przelicznik),2);

    ---Zafakturowanie/odfakturowanie
    IF (OLD.tr_rodzaj=2) THEN
     IF (COALESCE(NEW.tr_skojlog,0)<>0 AND (COALESCE(OLD.tr_skojlog,0)=0)) THEN 
      niezafaktwz_kwz=(SELECT SUM(ROUND(((kwz.tr_dozaplaty-kwz.tr_zaplacono)*kwz.tr_przelicznik),2)) FROM tg_transakcje AS kwz WHERE kwz.tr_skojarzona=OLD.tr_idtrans AND kwz.tr_rodzaj=12);
      UPDATE tb_klient SET k_niezafaktwz[fm_idind]=(NullZero(k_niezafaktwz[fm_idind])-niezafaktwz_old-niezafaktwz_kwz) WHERE k_idklienta=OLD.k_idklienta;
     ELSE
      IF (COALESCE(NEW.tr_skojlog,0)=0 AND (COALESCE(OLD.tr_skojlog,0)<>0)) THEN
       niezafaktwz_kwz=(SELECT SUM(ROUND(((kwz.tr_dozaplaty-kwz.tr_zaplacono)*kwz.tr_przelicznik),2)) FROM tg_transakcje AS kwz WHERE kwz.tr_skojarzona=OLD.tr_idtrans AND kwz.tr_rodzaj=12);
       UPDATE tb_klient SET k_niezafaktwz[fm_idind]=(NullZero(k_niezafaktwz[fm_idind])+niezafaktwz+niezafaktwz_kwz) WHERE k_idklienta=NEW.k_idklienta;
      END IF; --- odfakturowanie
     END IF; --- zafakturowanie
    END IF; --- WZ

    ---Zmiana klienta jednemu dodaje d
    IF ((COALESCE(OLD.tr_skojlog,0)=0 AND (COALESCE(NEW.tr_skojlog,0)=0)) OR OLD.tr_rodzaj=12) THEN
     IF (NEW.k_idklienta<>OLD.k_idklienta) THEN
      UPDATE tb_klient SET k_niezafaktwz[fm_idind]=(NullZero(k_niezafaktwz[fm_idind])-niezafaktwz_old) WHERE k_idklienta=OLD.k_idklienta;
      UPDATE tb_klient SET k_niezafaktwz[fm_idind]=(NullZero(k_niezafaktwz[fm_idind])+niezafaktwz) WHERE k_idklienta=NEW.k_idklienta;   
     ELSE
      UPDATE tb_klient SET k_niezafaktwz[fm_idind]=(NullZero(k_niezafaktwz[fm_idind])+niezafaktwz-niezafaktwz_old) WHERE k_idklienta=OLD.k_idklienta;
     END IF; --- klienci
    END IF; --- bylo i jest niezafakt
	
   END IF; --- update   
  END IF; --- cnt>0
 END IF; --- WZ/KWZ
 ------------------------------------------------------
 ---KONIEC pod liczenie niezafakt dla klienta
 ------------------------------------------------------


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
