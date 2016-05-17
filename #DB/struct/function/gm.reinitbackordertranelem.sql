CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 _date DATE;
 r RECORD;
BEGIN

 SELECT tel_newflaga,tel_flaga,tel_idelem,ttm_idtowmag,tr_idtrans,
        tel_iloscf,tel_datazam,tr_datasprzedaz,tr_datawystaw,
	    zl_idzlecenia,tel_iloscdorezerwacji,prt_idpartii,tel_skojzam,tel_new2flaga,
        tel_sprzedaz		
 INTO r 
 FROM tg_transelem 
 JOIN tg_transakcje USING (tr_idtrans) 
 WHERE tel_idelem=_idelem;

 IF (r.tel_flaga IS NULL) THEN
  RETURN NULL;
 END IF;

 ----zarzadzanie backorderem dla dokumentow przychodowych (tylko w buforze)
 IF ((r.tel_newflaga&1)=1 AND (r.tel_newflaga&4)=0 AND (r.tel_flaga&1024)=0) THEN
  IF ((r.tel_flaga&16)=16) OR (r.tel_sprzedaz!=0) THEN
   ---transakcja zamknieta (zerujemy backorder)
   PERFORM gm.dodajBackOrderFull(r.tel_idelem,r.ttm_idtowmag,0,NOT TEisRozchod(r.tel_newflaga),2,
                                 ((r.tel_flaga&(4096+256)=256) AND NOT TEisUsluga(r.tel_flaga)),r.tr_idtrans,
							     FALSE,r.tr_datasprzedaz,r.zl_idzlecenia,r.tel_iloscdorezerwacji,NULL,NULL,r.tel_new2flaga);
  ELSE
   ---transakcja otwarta dodajemy do backorderu
   PERFORM gm.dodajBackOrderFull(r.tel_idelem,r.ttm_idtowmag,r.tel_iloscf,NOT TEisRozchod(r.tel_newflaga),2,
                                 ((r.tel_flaga&(4096+256)=256) AND NOT TEisUsluga(r.tel_flaga)),r.tr_idtrans,
								 FALSE,r.tr_datasprzedaz,r.zl_idzlecenia,r.tel_iloscdorezerwacji,r.prt_idpartii,r.tel_skojzam,r.tel_new2flaga,
								 (r.tel_newflaga&(1<<31))<>0);
  END IF;
 END IF;
 --- BackOrder dla dokumentow o zachowaniu z robieniem backordera (DIZW_ISBACKORDERSOURCE)
 IF ((r.tel_flaga&524288)=524288) THEN             
  ---pobieram date waznosci backorderu
  IF (r.tel_datazam IS NOT NULL) THEN
   _date=r.tel_datazam;
  ELSE
   _date=r.tr_datawystaw;
  END IF;
  IF (r.tel_flaga&1024=0) THEN
   PERFORM gm.dodajBackOrderFull(r.tel_idelem,r.ttm_idtowmag,r.tel_iloscf,NOT TEisRozchod(r.tel_newflaga),2,
                                ((r.tel_flaga&(4096+256)=256) AND NOT TEisUsluga(r.tel_flaga)),r.tr_idtrans,
								FALSE,_date,r.zl_idzlecenia,r.tel_iloscdorezerwacji,r.prt_idpartii,r.tel_skojzam,r.tel_new2flaga,
								(r.tel_newflaga&(1<<31))<>0);
  ELSE
   PERFORM gm.dodajBackOrderFull(r.tel_idelem,r.ttm_idtowmag,0,NOT TEisRozchod(r.tel_newflaga),2,
                                ((r.tel_flaga&(4096+256)=256) AND NOT TEisUsluga(r.tel_flaga)),r.tr_idtrans,
								FALSE,_date,r.zl_idzlecenia,r.tel_iloscdorezerwacji,NULL,NULL,r.tel_new2flaga);
  END IF;
 END IF;

 RETURN NULL;
END;
$$;
