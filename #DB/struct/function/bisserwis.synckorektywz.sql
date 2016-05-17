CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _ttw_idtowaru ALIAS FOR $1;
 _dataod       ALIAS FOR $2;
 r             RECORD;
 rin           RECORD;
 pozostalo     NUMERIC;
 tmp           NUMERIC;
 petla         BOOL;
BEGIN
 --- Sprawdz najpierw czy z rozliczeniami korekt jest wszystko OK
 FOR r IN SELECT te.*,tr.k_idklienta,nullZero(rl.sumilosc) AS sumilosc FROM tg_transelem AS te 
                 JOIN tg_transakcje AS tr USING (tr_idtrans)
		 LEFT OUTER JOIN bisserwis.kzv_rozliczonepzkwz AS rl ON (rl.tel_idelem=te.tel_idelem)
                 WHERE tr.tr_rodzaj IN (12) AND
		       tr.tr_zamknieta&1=1 AND
		       te.ttw_idtowaru=_ttw_idtowaru AND
		       te.tel_iloscf<0 AND
		       -te.tel_iloscf<>nullZero(rl.sumilosc) AND
                       tr.tr_datasprzedaz>=_dataod
		 ORDER BY -tel_iloscf<sumilosc DESC,te.tel_idelem
 LOOP
  IF (-r.tel_iloscf>r.sumilosc) THEN
   pozostalo=-r.tel_iloscf-r.sumilosc;

   ---- Pozostalo cos do rozliczenia - szukaj rekordu z ktorym mozna rozliczyc
   FOR rin IN SELECT te.*,nullZero(rl.sumilosc) AS sumilosc 
              FROM tg_transelem AS te
	      JOIN tg_transakcje AS tr USING (tr_idtrans)
              LEFT OUTER JOIN bisserwis.kzv_rozliczonepzwz AS rl ON (rl.tel_idelem=te.tel_idelem)
	      WHERE te.ttw_idtowaru=r.ttw_idtowaru AND
	             te.tel_iloscf>0 AND
		     te.tel_iloscf>nullZero(rl.sumilosc) AND
		     te.tr_idtrans=r.tr_idtrans AND
 		     tr.tr_datasprzedaz>=_dataod
	      ORDER BY te.tel_skojarzony=r.tel_skojarzony DESC,te.tel_idelem
   LOOP
    tmp=min(pozostalo,rin.tel_iloscf-rin.sumilosc);
    PERFORM bisserwis.dodajRozliczenieWZBS(rin.tel_idelem,NULL,r.tel_idelem,13,tmp);
    pozostalo=pozostalo-tmp;
   END LOOP;
   ---- Szukaj normalnej WZetki z ktora mozna jeszcze rozliczyc
   FOR rin IN SELECT te.*,nullZero(rl.sumilosc) AS sumilosc 
              FROM tg_transelem AS te
              JOIN tg_transakcje AS tr USING (tr_idtrans)
              LEFT OUTER JOIN bisserwis.kzv_rozliczonepzwz AS rl ON (rl.tel_idelem=te.tel_idelem)
              WHERE tr.tr_rodzaj IN (2,12) AND
		    tr.tr_zamknieta&1=1 AND
	            te.ttw_idtowaru=r.ttw_idtowaru AND
	            te.tel_iloscf>0 AND
		    te.tel_iloscf>nullZero(rl.sumilosc) AND
		    pozostalo>0 AND
		    tr.k_idklienta=r.k_idklienta AND
 		    tr.tr_datasprzedaz>=_dataod
	      ORDER BY te.tel_idelem=r.tel_skojarzony DESC,te.tel_idelem
   LOOP
    tmp=min(pozostalo,rin.tel_iloscf-rin.sumilosc);
    PERFORM bisserwis.dodajRozliczenieWZBS(rin.tel_idelem,NULL,r.tel_idelem,13,tmp);
    pozostalo=pozostalo-tmp;
   END LOOP;
  ELSE
   ---Trzeba zmniejszac ilosci
   pozostalo=r.sumilosc-(-r.tel_iloscf);
   pozostalo=pozostalo-bisserwis.syncKorektyWZ(r.tel_idelem,r.tel_skojarzony,NULL,pozostalo);
  END IF;

  IF (pozostalo>0) THEN
   RAISE EXCEPTION 'Nie mozna rozliczyc korekty WZetki %',pozostalo;
  END IF;

 END LOOP;

 RETURN TRUE;
END;$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelem     ALIAS FOR $1;
 _skojarzony ALIAS FOR $2;
 _idplanu    ALIAS FOR $3;
 _ilosc      ALIAS FOR $4;
 petla       BOOL;
 rin         RECORD;
 pozostalo   NUMERIC;
 tmp         NUMERIC;
BEGIN
 pozostalo=_ilosc;
 ---START: Zmniejszanie na nadmiarach-------------------------------------------------------------------
 petla=TRUE;
 LOOP
  petla=FALSE;
  ---Najpierw zmniejszaj tam gdzie jest nadmiar wzgledem dokumentu pierwotnego
  FOR rin IN SELECT rpzam.rm_iloscf,rl.sumilosc,rm_idrealizacji,te.tel_iloscf
             FROM tg_realizacjapzam AS rpzam
             JOIN tg_transelem AS te ON (te.tel_idelem=rpzam.tel_idelemsrc)
 	     JOIN bisserwis.kzv_rozliczonepzwz AS rl ON (rl.tel_idelem=te.tel_idelem)
	     WHERE (CASE WHEN _idelem IS NULL THEN rpzam.tel_idpzam IS NULL ELSE rpzam.tel_idpzam=_idelem END)
             AND rpzam.rm_powod IN (12,13)
	     AND rl.sumilosc>te.tel_iloscf 
	     AND rpzam.rm_iloscf>0
	     AND pozostalo>0
	     AND (CASE WHEN _idplanu IS NULL THEN rpzam.pz_idplanu IS NULL ELSE rpzam.pz_idplanu=_idplanu END)
	     LIMIT 1
  LOOP
   tmp=min(pozostalo,min(rin.rm_iloscf,rin.sumilosc-rin.tel_iloscf));
   UPDATE tg_realizacjapzam SET rm_iloscf=rm_iloscf-tmp WHERE rm_idrealizacji=rin.rm_idrealizacji;
   pozostalo=pozostalo-tmp;
   petla=TRUE;
  END LOOP;
  EXIT WHEN petla=FALSE;
 END LOOP;
 ---END: Zmniejszanie na nadmiarach---------------------------------------------------------------------
 ---START: Zmniejszanie gdziekolwiek--------------------------------------------------------------------
 FOR rin IN SELECT rpzam.rm_iloscf,rm_idrealizacji
            FROM tg_realizacjapzam AS rpzam
            JOIN tg_transelem AS te ON (te.tel_idelem=rpzam.tel_idelemsrc)
	    WHERE (CASE WHEN _idelem IS NULL THEN rpzam.tel_idpzam IS NULL ELSE rpzam.tel_idpzam=_idelem END)
	    AND rpzam.rm_powod IN (12,13)
	    AND rpzam.rm_iloscf>0
	    AND pozostalo>0
            AND (CASE WHEN _idplanu IS NULL THEN rpzam.pz_idplanu IS NULL ELSE rpzam.pz_idplanu=_idplanu END)
	    ORDER BY te.tel_skojarzony<>_skojarzony DESC
 LOOP
  tmp=min(pozostalo,rin.rm_iloscf);
  UPDATE tg_realizacjapzam SET rm_iloscf=rm_iloscf-tmp WHERE rm_idrealizacji=rin.rm_idrealizacji AND tmp<>0;
  pozostalo=pozostalo-tmp;
 END LOOP;
 ---END: Zmniejszanie gdziekolwiek----------------------------------------------------------------------
 RETURN _ilosc-pozostalo;
END;$_$;
