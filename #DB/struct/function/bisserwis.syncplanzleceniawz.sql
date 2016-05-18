CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _pz_idplanu   ALIAS FOR $1;
 _ttw_idtowaru ALIAS FOR $2;
 _ilosc        ALIAS FOR $3;
 _dataod       ALIAS FOR $4;
 r             RECORD;
 rin           RECORD;
 pozostalo     NUMERIC;
 tmp           NUMERIC;
BEGIN
 
 pozostalo=nullZero((SELECT sumilosc FROM bisserwis.kzv_rozliczonepzwzpz WHERE pz_idplanu=_pz_idplanu));
 IF (pozostalo=_ilosc) THEN
  RETURN TRUE;
 END IF;

 --Najpierw upewnij sie ze wszystko jest ok z korektami WZ
 PERFORM bisserwis.syncKorektyWZ(_ttw_idtowaru,_dataod);

 pozostalo=nullZero((SELECT sumilosc FROM bisserwis.kzv_rozliczonepzwzpz WHERE pz_idplanu=_pz_idplanu));
 IF (pozostalo=_ilosc) THEN
  RETURN TRUE;
 END IF;

 IF (pozostalo<_ilosc) THEN
  pozostalo=_ilosc-pozostalo;

  FOR rin IN SELECT te.*,nullZero(rl.sumilosc) AS sumilosc FROM tg_transelem AS te
             JOIN tg_transakcje AS tr USING (tr_idtrans)
             LEFT OUTER JOIN bisserwis.kzv_rozliczonepzwz AS rl ON (rl.tel_idelem=te.tel_idelem)
             WHERE tr.tr_rodzaj IN (2,12) AND
            	   tr.tr_zamknieta&1=1 AND
	           te.ttw_idtowaru=_ttw_idtowaru AND
	           te.tel_iloscf>0 AND
		   te.tel_iloscf>nullZero(rl.sumilosc) AND
		   pozostalo>0 AND
		   te.tel_idklienta=(SELECT zl.k_idklienta FROM tg_planzlecenia AS pz JOIN tg_zlecenia AS zl USING (zl_idzlecenia) WHERE pz.pz_idplanu=_pz_idplanu) AND
		   tr.tr_datasprzedaz>=_dataod
	     ORDER BY te.tel_idelem
   LOOP
    tmp=min(pozostalo,rin.tel_iloscf-rin.sumilosc);
    PERFORM bisserwis.dodajRozliczenieWZBS(rin.tel_idelem,_pz_idplanu,NULL,12,tmp);
    pozostalo=pozostalo-tmp;
   END LOOP;
 ELSE
  pozostalo=pozostalo-_ilosc;
  --- O tyle trzeba zmniejszyc!
  pozostalo=pozostalo-bisserwis.syncKorektyWZ(NULL,NULL,_pz_idplanu,pozostalo);
 END IF;

 IF (pozostalo>0) THEN
  RAISE EXCEPTION '31|%:%:%|Nie mozna rozliczyc planu zlecenia',_pz_idplanu,_ttw_idtowaru,pozostalo;
 END IF;

 RETURN TRUE; 
END;$_$;
