CREATE FUNCTION rozliczvatzalp(_idrozliczenia integer, _idrozrachunku integer, _brutto numeric, _isleft boolean, _idtransfv integer DEFAULT NULL::integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 r                      RECORD;
 seq                    INT;
 wsp                    NUMERIC:=1;
 brutto                 NUMERIC;          --- Wartosc do rozliczenia

 czastka                NUMERIC;
 czastkav               NUMERIC;
 czastkan               NUMERIC;

 rozliczono             NUMERIC;
 pozostalo              NUMERIC;
 sumabrutto             NUMERIC;
 
 idtransfv              INTEGER;
BEGIN
 seq=nextval('tb_vatzal_s');
 idtransfv = _idtransfv;

 --- + jesli rozliczam z Wn, - jesli z Ma
 brutto=_brutto;

 IF (brutto<0) THEN
  wsp=-wsp;
  brutto=-brutto;
 END IF;

 wsp=-1;

 ---Ile juz rozliczono
 EXECUTE 'SELECT sum(vz_brutto) FROM tb_vatzal WHERE rl_idrozliczenia=$1 AND vz_isleft=$2' INTO rozliczono USING _idrozliczenia,_isleft;
 rozliczono=nullZero(wsp*rozliczono);
 pozostalo=brutto-rozliczono;
 IF (pozostalo=0) THEN
  RETURN TRUE;
 END IF;

 ---Ile mozna rozliczyc
 IF (idtransfv IS NULL) THEN
  idtransfv=(SELECT rr.tr_idtrans FROM kr_rozliczenia AS rl 
                                JOIN kr_rozrachunki AS rr ON (rr.rr_idrozrachunku=(CASE WHEN rl.rr_idrozrachunkul=_idrozrachunku THEN rl.rr_idrozrachunkur ELSE rl.rr_idrozrachunkul END)) 
	  	 	       JOIN tg_transakcje AS tr USING (tr_idtrans)
		 	       WHERE rl.rl_idrozliczenia=_idrozliczenia AND tr_zamknieta&1=0
		 	      );
 END IF;		
 
 EXECUTE 'SELECT sum(ret.brutto) 
          FROM vatviews.kv_raport_bystawka_ret AS ret
          JOIN tb_vatzal AS v ON (ret.tel_stvat=v.vz_stawkavat AND ret.tel_zw=v.vz_flagazw)
          WHERE ret.tr_idtrans=$1 AND v.rr_idrozrachunku=$2' INTO sumabrutto USING idtransfv,_idrozrachunku;		 

 IF (idtransfv IS NULL) THEN
  RAISE EXCEPTION 'Nie mozna przeliczac zaliczek na zamknietym dokumencie!';
 END IF;

 IF (rozliczono<>0) THEN
  EXECUTE 'DELETE FROM tb_vatzal WHERE rl_idrozliczenia=$1 AND vz_isleft=$2' USING _idrozliczenia,_isleft;
  rozliczono=0;
  EXECUTE 'SELECT sum(ret.brutto) 
           FROM vatviews.kv_raport_bystawka_ret AS ret
           JOIN tb_vatzal AS v ON (ret.tel_stvat=v.vz_stawkavat AND ret.tel_zw=v.vz_flagazw)
           WHERE ret.tr_idtrans=$1 AND v.rr_idrozrachunku=$2' INTO sumabrutto USING idtransfv,_idrozrachunku;
  pozostalo=brutto-rozliczono;
 END IF;

 IF (pozostalo>0) THEN
  FOR r IN EXECUTE 'SELECT * FROM vatviews.kv_raport_bystawka_ret AS ret
                    JOIN tb_vatzal AS v ON (ret.tel_stvat=v.vz_stawkavat AND ret.tel_zw=v.vz_flagazw)
		    WHERE ret.tr_idtrans=$1 AND v.rr_idrozrachunku=$2
		    ORDER BY vz_stawkavat,vz_flagazw' USING idtransfv,_idrozrachunku
  LOOP

   IF (sumabrutto<>0) THEN
    czastka=floorRoundMax((brutto-rozliczono)*r.brutto/sumabrutto,pozostalo);
   ELSE
    czastka=0;
   END IF;

   ----RAISE NOTICE 'Czastka brutto % rozliczono % r.brutto % sumabrutto % ',brutto,rozliczono,r.brutto,sumabrutto;
   czastkan=-wsp*(r.vz_vat+r.vz_vatroz);

   IF (czastka=-wsp*(r.vz_brutto+r.vz_bruttoroz)) THEN
    czastkav=-wsp*(r.vz_vat+r.vz_vatroz);
   ELSIF (czastka=r.brutto) THEN
    czastkav=min(r.vat,-wsp*(r.vz_vat+r.vz_vatroz));
   ELSE
    czastkav=floorRoundMax(r.vat*czastka/r.brutto,min(r.vat,-wsp*(r.vz_vat+r.vz_vatroz)));
   END IF;
   ---RAISE EXCEPTION 'Czastka % % (% i %)',czastkan,czastkav,czastka,r.brutto;
   czastkan=czastka-czastkav;


   IF (czastka<>0) THEN
    RAISE NOTICE 'Netto %, VAT %, Brutto % wsp % ',czastkan,czastkav,czastka,wsp;
    EXECUTE 'INSERT INTO tb_vatzal
     (tr_idtrans,rl_idrozliczenia,vz_refid,
      vz_netto,vz_vat,vz_brutto,
      vz_stawkavat,vz_flagazw,vz_sequpd,vz_isleft)
     VALUES
	  ($1,$2,$3,
	   $4,$5,$6,
	   $7,$8,$9,$10)'
	 USING idtransfv,_idrozliczenia,r.vz_id,
           wsp*czastkan,wsp*czastkav,wsp*czastka,
           r.vz_stawkavat,r.vz_flagazw,seq,_isleft;
   END IF;

   pozostalo=pozostalo-czastka;
  END LOOP;

  IF (pozostalo>0) THEN
   FOR r IN EXECUTE 'SELECT * FROM vatviews.kv_raport_bystawka_ret AS ret
                     JOIN tb_vatzal AS v ON (ret.tel_stvat=v.vz_stawkavat AND ret.tel_zw=v.vz_flagazw)
 		             WHERE ret.tr_idtrans=$1 AND v.rr_idrozrachunku=$2
 		             ORDER BY vz_stawkavat,vz_flagazw' USING idtransfv,_idrozrachunku
   LOOP   
    czastka=floorRoundMax(-wsp*(r.vz_brutto+r.vz_bruttoroz),pozostalo);

    IF (czastka=-wsp*(r.vz_brutto+r.vz_bruttoroz)) THEN
     czastkav=-wsp*(r.vz_vat+r.vz_vatroz);
    ELSE
     czastkav=floorRoundMax(-(r.vz_vat+r.vz_vatroz)*czastka/(-(r.vz_brutto+r.vz_bruttoroz)),-wsp*(r.vz_vat+r.vz_vatroz));
    END IF;
    czastkan=czastka-czastkav;
    RAISE NOTICE 'Netto %, VAT %, Brutto % ',czastkan,czastkav,czastka;

    IF (czastka<>0) THEN
     EXECUTE 'INSERT INTO tb_vatzal
      (tr_idtrans,rl_idrozliczenia,vz_refid,
       vz_netto,vz_vat,vz_brutto,
       vz_stawkavat,vz_flagazw,vz_sequpd,vz_isleft)
     VALUES
      ($1,$2,$3,
	   $4,$5,$6,
	   $7,$8,$9,$10)
	 ' USING idtransfv,_idrozliczenia,r.vz_id,
       wsp*czastkan,wsp*czastkav,wsp*czastka,
       r.vz_stawkavat,r.vz_flagazw,seq,_isleft;
    END IF;

    pozostalo=pozostalo-czastka;
   END LOOP;
  END IF;

  IF (pozostalo>0) THEN
   RAISE EXCEPTION '48|%|Nie mozna rozliczyc VAT na fakturze zaliczkowej',_idrozrachunku;
  END IF;

 END IF;

 IF (_idtransfv IS NULL) THEN
  UPDATE tg_transakcje SET tr_zamknieta=tr_zamknieta|(1<<20) WHERE tr_idtrans=idtransfv AND ((tr_zamknieta&(1<<20))=0);
 END IF;
 
 RETURN TRUE;
END;
$_$;
