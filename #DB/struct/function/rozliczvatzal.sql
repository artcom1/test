CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 r                      RECORD;
 seq                    INT;
 wsp                    NUMERIC:=1;
 brutto                 NUMERIC;          --- Wartosc do rozliczenia
 idtransfv              INT;

 czastka                NUMERIC;
 czastkav               NUMERIC;
 czastkan               NUMERIC;

 dorozliczenia          NUMERIC;
 rozliczono             NUMERIC;
 pozostalo              NUMERIC;
BEGIN
 seq=nextval('tb_vatzal_s');
 idtransfv=_idtransfv;

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
 ---Ile mozna rozliczyc
 EXECUTE 'SELECT sum(vz_brutto+vz_bruttoroz) FROM tb_vatzal WHERE rr_idrozrachunku=$1' INTO dorozliczenia USING _idrozrachunku;
 dorozliczenia=-wsp*dorozliczenia;
    
 pozostalo=brutto-rozliczono;

 ---RAISE EXCEPTION 'Rozliczono % do rozliczenia % pozostalo %',rozliczono,dorozliczenia,pozostalo;

 IF (pozostalo=0) THEN
  RETURN TRUE;
 END IF;

 IF (rozliczono<>0) THEN
  EXECUTE 'DELETE FROM tb_vatzal WHERE rl_idrozliczenia=$1 AND vz_isleft=$2' USING _idrozliczenia,_isleft;
  rozliczono=0;
  EXECUTE 'SELECT sum(vz_brutto+vz_bruttoroz) FROM tb_vatzal WHERE rr_idrozrachunku=$1' INTO dorozliczenia USING _idrozrachunku;
  dorozliczenia=-wsp*dorozliczenia;
  pozostalo=brutto-rozliczono;
 END IF;

 ----RAISE NOTICE 'Mam % % % ',rozliczono,dorozliczenia,pozostalo;
 IF (pozostalo>0) THEN

  IF (idtransfv IS NULL) THEN
   idtransfv=(SELECT rr.tr_idtrans FROM kr_rozliczenia AS rl JOIN kr_rozrachunki AS rr ON (rr.rr_idrozrachunku=(CASE WHEN rl.rr_idrozrachunkul=_idrozrachunku THEN rl.rr_idrozrachunkur ELSE rl.rr_idrozrachunkul END)) WHERE rl.rl_idrozliczenia=_idrozliczenia);
  END IF;   

  FOR r IN EXECUTE 'SELECT * FROM tb_vatzal WHERE rr_idrozrachunku=$1 ORDER BY vz_stawkavat,vz_flagazw' USING _idrozrachunku
  LOOP   
   IF (dorozliczenia<>0) THEN
    czastka=floorRoundMax(-wsp*(brutto-rozliczono)*(r.vz_brutto+r.vz_bruttoroz)/dorozliczenia,pozostalo);
   ELSE
    czastka=0;
   END IF;

   IF (czastka=-wsp*(r.vz_brutto+r.vz_bruttoroz)) THEN
    czastkav=-wsp*(r.vz_vat+r.vz_vatroz);
   ELSE
    czastkav=floorRoundMax(-(r.vz_vat+r.vz_vatroz)*czastka/(-(r.vz_brutto+r.vz_bruttoroz)),-wsp*(r.vz_vat+r.vz_vatroz));
   END IF;
   czastkan=czastka-czastkav;

   ----RAISE NOTICE 'Netto %, VAT %, Brutto % (stawka %)',czastkan,czastkav,czastka,r.vz_stawkavat;

   IF (czastka<>0) THEN
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
   FOR r IN EXECUTE 'SELECT * FROM tb_vatzal WHERE rr_idrozrachunku=$1 ORDER BY vz_stawkavat,vz_flagazw' USING _idrozrachunku
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
	   $4,$5,$6
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
 
 RETURN TRUE;
END;
$_$;
