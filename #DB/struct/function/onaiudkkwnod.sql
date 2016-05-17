CREATE FUNCTION onaiudkkwnod() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltarbh       NUMERIC:=0;
 deltacw        NUMERIC:=0; 
 deltawyk_new   NUMERIC:=0; 
 deltawyk_old   NUMERIC:=0; 
 head INT; 
 przeliczamydateKKWNODstop BOOL:=FALSE;
 _kwe_idprev INT;
 _spo_idspinaczaOld INT;
BEGIN
 IF (TG_OP='INSERT') THEN
  IF (NEW.kwe_nodtype=0) THEN
   ---ustalamy tylko normy dla normalnej operacji, kooperacje w to nie wchodza
   deltarbh=NEW.kwe_wykonanepracrbh;
   deltacw=NEW.kwe_czaswolnypracrbh;
  END IF;
  head=NEW.kwh_idheadu;
  NEW.kwe_datazakonczenia_prev=(SELECT kwh_datarozp FROM tr_kkwhead WHERE kwh_idheadu=NEW.kwh_idheadu);
  
  -- Ilosc wykonana wyroby na KKW
  IF ((NEW.the_flaga&(1<<0))=(1<<0) AND NEW.kwe_mnoznikwyrobu_l<>0) THEN
   deltawyk_new=NEW.kwe_iloscwyk*NEW.kwe_mnoznikwyrobu_m/NEW.kwe_mnoznikwyrobu_l;
  END IF;
  -- Ilosc wykonana wyroby na KKW
 END IF;

 IF (TG_OP='UPDATE') THEN
   -- Ilosc wykonana wyroby na KKW
  IF ((NEW.the_flaga&(1<<0))=(1<<0) AND NEW.kwe_mnoznikwyrobu_l<>0) THEN
   deltawyk_new=NEW.kwe_iloscwyk*NEW.kwe_mnoznikwyrobu_m/NEW.kwe_mnoznikwyrobu_l;
  END IF;
  
  IF ((OLD.the_flaga&(1<<0))=(1<<0) AND OLD.kwe_mnoznikwyrobu_l<>0) THEN
   deltawyk_old=OLD.kwe_iloscwyk*OLD.kwe_mnoznikwyrobu_m/OLD.kwe_mnoznikwyrobu_l;
  END IF;
  -- Ilosc wykonana wyroby na KKW
  
  ---przenoszenie czasow wykonania na KKW
  IF (NEW.kwe_nodtype=0 AND OLD.kwe_nodtype=0) THEN
   deltarbh=NEW.kwe_wykonanepracrbh-OLD.kwe_wykonanepracrbh;
   deltacw=NEW.kwe_czaswolnypracrbh-OLD.kwe_czaswolnypracrbh;
  END IF;

  IF (NEW.kwe_nodtype=0 AND OLD.kwe_nodtype=1) THEN
   deltarbh=NEW.kwe_wykonanepracrbh;
   deltacw=NEW.kwe_czaswolnypracrbh;
  END IF;

  IF (NEW.kwe_nodtype=1 AND OLD.kwe_nodtype=0) THEN
   deltarbh=-OLD.kwe_wykonanepracrbh;
   deltacw=-OLD.kwe_czaswolnypracrbh;
  END IF;

  head=NEW.kwh_idheadu;

  IF ((OLD.kwe_flaga&2048)<>(NEW.kwe_flaga&2048)) THEN
   UPDATE tr_kkwnodplan SET knp_flaga=flagMask(knp_flaga,1,(((NEW.kwe_flaga>>11)&1)=1)) WHERE kwe_idelemu=NEW.kwe_idelemu;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
   -- Ilosc wykonana wyroby na KKW  
  IF ((OLD.the_flaga&(1<<0))=(1<<0) AND OLD.kwe_mnoznikwyrobu_l<>0) THEN
   deltawyk_old=OLD.kwe_iloscwyk*OLD.kwe_mnoznikwyrobu_m/OLD.kwe_mnoznikwyrobu_l;
  END IF;
  -- Ilosc wykonana wyroby na KKW
  
  IF (OLD.kwe_nodtype=0) THEN
   deltarbh=OLD.kwe_wykonanepracrbh;
   deltacw=OLD.kwe_czaswolnypracrbh;
  END IF;
  head=OLD.kwh_idheadu;
 END IF;

 IF (deltarbh<>0 OR deltacw<>0 OR (deltawyk_new-deltawyk_old)<>0 ) THEN ---uaktualniamy czasy wykonania na KKW
  UPDATE tr_kkwhead SET 
  kwh_wykonanepracrbh=kwh_wykonanepracrbh+deltarbh, 
  kwh_czaswolnypracrbh=kwh_czaswolnypracrbh+deltacw,
  kwh_iloscwyk=kwh_iloscwyk+round((deltawyk_new-deltawyk_old),4)
  WHERE kwh_idheadu=head;
 END IF;

 ---------------------------------------------------------------------------------------------------------------
 ---Aktualizacja terminu zakonczenia wykonan 
 IF (TG_OP='UPDATE') THEN
  IF (
      (OLD.kwe_datazakonczenia IS NULL AND NEW.kwe_datazakonczenia IS NOT NULL) OR
      (OLD.kwe_datazakonczenia IS NOT NULL AND NEW.kwe_datazakonczenia IS NULL) OR
      (OLD.kwe_datazakonczenia <> NEW.kwe_datazakonczenia) OR
      (OLD.kwe_iloscpoprzednikow <> NEW.kwe_iloscpoprzednikow)
     ) THEN
   przeliczamydateKKWNODstop=TRUE;
   _kwe_idprev=NEW.kwe_idelemu;
   
   UPDATE tr_kkwnod AS unod SET 
   kwe_datazakonczenia_prev=
   (
    SELECT 
    max(kwe_datazakonczenia)
    FROM tr_kkwnodprevnext AS pn 
    JOIN tr_kkwnod AS nod ON (nod.kwe_idelemu=pn.kwe_idprev) 
    WHERE kwe_idnext=unod.kwe_idelemu
   )
   WHERE
   unod.kwe_idelemu IN (SELECT kwe_idnext FROM tr_kkwnodprevnext WHERE kwe_idprev=_kwe_idprev);  
  END IF;
 END IF;
 
 IF (TG_OP='INSERT') THEN
  IF (NEW.kwe_datazakonczenia IS NOT NULL) THEN
   przeliczamydateKKWNODstop=TRUE;
   _kwe_idprev=NEW.kwe_idelemu;
  END IF;
 END IF; 
 
 IF (TG_OP='DELETE') THEN
  przeliczamydateKKWNODstop=TRUE;
  _kwe_idprev=OLD.kwe_idelemu;  
 END IF; 
 
 IF (przeliczamydateKKWNODstop) THEN  
  IF (COALESCE(head,0)>0) THEN    
   UPDATE tr_kkwhead AS kwh SET 
   kwh_datazakonczenianodow=
   (
    SELECT 
(CASE WHEN dataz::date='2079-11-29'::DATE THEN NULL ELSE dataz END) 
FROM 
(SELECT max(COALESCE(kwe_datazakonczenia,'2079-11-29')) AS dataz FROM tr_kkwnod WHERE kwh_idheadu=head) AS a
   ),
   kwh_flaga=(CASE WHEN COALESCE((SELECT count(*) FROM tr_kkwnod WHERE kwh_idheadu=head AND kwe_datazakonczenia IS NOT NULL AND kwe_iloscpoprzednikow=0),0)>0 THEN kwh_flaga|(1<<8) ELSE kwh_flaga&(~(1<<8)) END)
   WHERE kwh.kwh_idheadu=head;
  END IF;
  
 END IF;
 ---Koniec: Aktualizacja terminu zakonczenia wykonan
 ---------------------------------------------------------------------------------------------------------------

 ---------------------------------------------------------------------------------------------------------------
 --- Aktualizacja spinaczy
 IF (TG_OP='DELETE') THEN -- Robie delete, zawsze aktualizuje spinacz
  _spo_idspinaczaOld=OLD.spo_idspinacza;
 END IF; 
 
 IF (TG_OP='UPDATE') THEN -- Robie update, aktualizuje spinacz jesli sie zmienil
  IF (COALESCE(NEW.spo_idspinacza,0)<>COALESCE(OLD.spo_idspinacza,0)) THEN
   _spo_idspinaczaOld=OLD.spo_idspinacza;
  END IF;
 END IF; 
 
 IF (COALESCE(_spo_idspinaczaOld,0)>0) THEN -- Musze zaktualizowac stary spinacz
  PERFORM aktOpDomSpinaczaKKWNodPoUsunieciu(_spo_idspinaczaOld,OLD.kwe_idelemu);
 END IF; 
 --- Koniec: Aktualizacja spinaczy
 ---------------------------------------------------------------------------------------------------------------
 
  ---------------------------------------------------------------------
 ----UAKTUALNIAMY ARRAY planowanych ilosci dla nodrecrozmiarowka
 --------------------------------------------------------------------- 
IF (TG_OP='UPDATE') THEN
 IF (
     NEW.kwe_iloscplanwyk_array IS DISTINCT FROM OLD.kwe_iloscplanwyk_array  OR
     NEW.kwe_iloscwyk_array     IS DISTINCT FROM OLD.kwe_iloscwyk_array
	) THEN
  RAISE NOTICE '+: kwe_iloscplanwyk_array: %->%, kwe_iloscwyk_array: %->%', OLD.kwe_iloscplanwyk_array, NEW.kwe_iloscplanwyk_array, OLD.kwe_iloscwyk_array, NEW.kwe_iloscwyk_array;
  UPDATE tr_nodrecrozmiarowka SET knr_idelemu=knr_idelemu WHERE knr_idelemu IN (SELECT knr_idelemu FROM tr_nodrec WHERE kwe_idelemu=NEW.kwe_idelemu);
 ELSE
  RAISE NOTICE '-: kwe_iloscplanwyk_array: %->%, kwe_iloscwyk_array: %->%', OLD.kwe_iloscplanwyk_array, NEW.kwe_iloscplanwyk_array, OLD.kwe_iloscwyk_array, NEW.kwe_iloscwyk_array; 
 END IF;
END IF;
 ---------------------------------------------------------------------
 ----KONIEC UAKTUALNIAMY ARRAY planowanych ilosci dla nodrecrozmiarowka
 ---------------------------------------------------------------------

 ---------------------------------------------------------------------
 ----UAKTUALNIAMY ILOSCI NA ROZCHODACH ZWIAZANYCH Z NODEM
 --------------------------------------------------------------------- 
IF (TG_OP='UPDATE') THEN
  UPDATE tr_nodrec SET 
  knr_iloscplan=KKWNODobliczilosc(NEW.kwe_iloscplanwyk,NEW.kwe_iloscplanbrak,knr_licznik,knr_mianownik,trr_flaga,knr_flaga),
  knr_iloscwyk=KKWNODobliczilosc(NEW.kwe_iloscwyk,NEW.kwe_iloscbrakow,knr_licznik,knr_mianownik,trr_flaga,knr_flaga)
  WHERE 
  kwe_idelemu=NEW.kwe_idelemu AND
  knr_flaga&(1<<12)=0 AND
  trr_flaga&4=0 AND
  (
   knr_iloscplan<>KKWNODobliczilosc(NEW.kwe_iloscplanwyk,NEW.kwe_iloscplanbrak,knr_licznik,knr_mianownik,trr_flaga,knr_flaga) OR
   knr_iloscwyk<>KKWNODobliczilosc(NEW.kwe_iloscwyk,NEW.kwe_iloscbrakow,knr_licznik,knr_mianownik,trr_flaga,knr_flaga)
  );
  
  UPDATE tr_nodrec SET
  knr_iloscplan=KKWNODobliczilosc(NEW.kwe_iloscplanstart,0,knr_licznik,knr_mianownik,trr_flaga,knr_flaga),
  knr_iloscwyk=KKWNODobliczilosc(NEW.kwe_iloscstart,0,knr_licznik,knr_mianownik,trr_flaga,knr_flaga)
  WHERE 
  kwe_idelemu=NEW.kwe_idelemu AND
  knr_flaga&(1<<12)=0 AND
  trr_flaga&4=4 AND
  (
   knr_iloscplan<>KKWNODobliczilosc(NEW.kwe_iloscplanstart,0,knr_licznik,knr_mianownik,trr_flaga,knr_flaga) OR
   knr_iloscwyk<>KKWNODobliczilosc(NEW.kwe_iloscstart,0,knr_licznik,knr_mianownik,trr_flaga,knr_flaga)
  );
  
  UPDATE tr_nodrec AS nr SET
  knr_iloscplan=array_sum(KKWNODObliczIlosc_ARRAY(NEW.kwe_iloscplanwyk_array,NULL,(SELECT knrr_rozmiarwyst FROM tr_nodrecrozmiarowka AS ro WHERE ro.knr_idelemu=nr.knr_idelemu),knr_licznik,knr_mianownik,trr_flaga,knr_flaga,0)),
  knr_iloscwyk=array_sum(KKWNODObliczIlosc_ARRAY(NEW.kwe_iloscwyk_array,NULL,(SELECT knrr_rozmiarwyst FROM tr_nodrecrozmiarowka AS ro WHERE ro.knr_idelemu=nr.knr_idelemu),knr_licznik,knr_mianownik,trr_flaga,knr_flaga,0))
  WHERE 
  kwe_idelemu=NEW.kwe_idelemu AND
  knr_flaga&(1<<12)=(1<<12); --AND
--  (
--   knr_iloscplan<>KKWNODobliczilosc(NEW.kwe_iloscplanstart,0,knr_licznik,knr_mianownik,trr_flaga,knr_flaga) OR
--   knr_iloscwyk<>KKWNODobliczilosc(NEW.kwe_iloscstart,0,knr_licznik,knr_mianownik,trr_flaga,knr_flaga)
--  );
END IF;
 ---------------------------------------------------------------------
 ----KONIEC UAKTUALNIAMY ILOSCI NA ROZCHODACH ZWIAZANYCH Z NODEM
 ---------------------------------------------------------------------
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
