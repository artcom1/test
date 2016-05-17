CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltaboold NUMERIC:=0;
 deltabonew NUMERIC:=0;
 backorder  NUMERIC:=0;
 flaga_backorder INT:=0;
 _data      DATE:=now();
 nod RECORD;
 kkwrec RECORD;
 deltaplan_roz NUMERIC:=0;
 deltaplan_wyk NUMERIC:=0;
 
 _iloscplanwyk NUMERIC:=0;
 _iloscplanbrak NUMERIC:=0;
 _iloscwyk NUMERIC:=0;
 _iloscplanstart NUMERIC:=0;
 _iloscstart NUMERIC:=0;
 _iloscbrakow NUMERIC:=0;
 
 _iloscplanwyk_array  NUMERIC[];
 _iloscwyk_array      NUMERIC[]; 
 _wystepowanie_array  NUMERIC[]; 
BEGIN
 
 IF (TG_OP='INSERT') THEN
  IF (NEW.kwe_idelemu IS NOT NULL) THEN
   NEW.kwh_idheadu=(SELECT kwh_idheadu FROM tr_kkwnod WHERE kwe_idelemu=NEW.kwe_idelemu);
   
   SELECT 
   kwe_iloscplanwyk, kwe_iloscplanbrak, kwe_iloscwyk, kwe_iloscplanstart, kwe_iloscstart, kwe_iloscbrakow,
   kwe_iloscplanwyk_array, kwe_iloscwyk_array
   INTO nod FROM tr_kkwnod 
   WHERE kwe_idelemu=NEW.kwe_idelemu;
   
   _iloscplanwyk=nod.kwe_iloscplanwyk;
   _iloscplanbrak=nod.kwe_iloscplanbrak;
   _iloscwyk=nod.kwe_iloscwyk;
   _iloscplanstart=nod.kwe_iloscplanstart;
   _iloscstart=nod.kwe_iloscstart;
   _iloscbrakow=nod.kwe_iloscbrakow;   
   _iloscplanwyk_array=nod.kwe_iloscplanwyk_array;
   _iloscwyk_array=nod.kwe_iloscwyk_array;
   
  ELSE  
   SELECT
   kwh_iloscoczek,kwh_iloscwmag,
   kwh_iloscoczek_array,kwh_iloscwyk_array
   INTO kkwrec FROM tr_kkwhead 
   WHERE kwh_idheadu=NEW.kwh_idheadu;
   
   _iloscplanwyk=kkwrec.kwh_iloscoczek;
   _iloscwyk=kkwrec.kwh_iloscwmag;
   _iloscplanwyk_array=kkwrec.kwh_iloscoczek_array;
   _iloscwyk_array=kkwrec.kwh_iloscwyk_array;
   
  END IF;
   
  --przeliczamy nowe ilosci
  IF ((NEW.knr_flaga&(1<<12))=(1<<12)) THEN -- dla rozmiarowki
   _wystepowanie_array=(SELECT knrr_rozmiarwyst FROM tr_nodrecrozmiarowka WHERE knr_idelemu=NEW.knr_idelemu);
   NEW.knr_iloscplan=array_sum(KKWNODObliczIlosc_ARRAY(_iloscplanwyk_array,NULL,_wystepowanie_array,NEW.knr_licznik,NEW.knr_mianownik,NEW.trr_flaga,NEW.knr_flaga,0));
   NEW.knr_iloscwyk=array_sum(KKWNODObliczIlosc_ARRAY(_iloscwyk_array,NULL,_wystepowanie_array,NEW.knr_licznik,NEW.knr_mianownik,NEW.trr_flaga,NEW.knr_flaga,0));
  ELSE -- dla zwyklych
   IF ((NEW.trr_flaga&4)=0) THEN
    NEW.knr_iloscplan=max(KKWNODobliczilosc(_iloscplanwyk,_iloscplanbrak,NEW.knr_licznik,NEW.knr_mianownik,NEW.trr_flaga,NEW.knr_flaga),NEW.knr_iloscmin);
    NEW.knr_iloscwyk=max(KKWNODobliczilosc(_iloscwyk,_iloscbrakow,NEW.knr_licznik,NEW.knr_mianownik,NEW.trr_flaga,NEW.knr_flaga),NEW.knr_iloscmin);
   END IF;  
   IF ((NEW.trr_flaga&4)=4) THEN
    NEW.knr_iloscplan=max(KKWNODobliczilosc(_iloscplanstart,0,NEW.knr_licznik,NEW.knr_mianownik,NEW.trr_flaga,NEW.knr_flaga),NEW.knr_iloscmin);
    NEW.knr_iloscwyk=max(KKWNODobliczilosc(_iloscstart,0,NEW.knr_licznik,NEW.knr_mianownik,NEW.trr_flaga,NEW.knr_flaga),NEW.knr_iloscmin);
   END IF;
  END IF;
  ---koniec przeliczania nowych ilosci 
  
  IF (NEW.knr_wplywmag=1) THEN 
   deltaplan_roz=NEW.knr_iloscplan;
   deltaplan_wyk=NEW.knr_iloscrozch;
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
 ---sprawdzamy czy sie zmienily przeliczniki, jesli tak to wyliczamy nowe ilosci
  IF (NEW.knr_licznik<>OLD.knr_licznik OR NEW.knr_mianownik<>OLD.knr_mianownik) THEN
   --przeliczamy nowe ilosci
   
   IF (NEW.kwe_idelemu IS NOT NULL) THEN
    SELECT
    kwe_iloscplanwyk,kwe_iloscplanbrak,kwe_iloscwyk,kwe_iloscplanstart,kwe_iloscstart,kwe_iloscbrakow,kwe_iloscplanwyk_array, kwe_iloscwyk_array
    INTO nod FROM tr_kkwnod
    WHERE kwe_idelemu=NEW.kwe_idelemu;
    _iloscplanwyk=nod.kwe_iloscplanwyk;
    _iloscplanbrak=nod.kwe_iloscplanbrak;
    _iloscwyk=nod.kwe_iloscwyk;
    _iloscplanstart=nod.kwe_iloscplanstart;
    _iloscstart=nod.kwe_iloscstart;
    _iloscbrakow=nod.kwe_iloscbrakow;
    _iloscplanwyk_array=nod.kwe_iloscplanwyk_array;
    _iloscwyk_array=nod.kwe_iloscwyk_array;
   ELSE   
    SELECT
    kwh_iloscoczek,kwh_iloscwmag,
    kwh_iloscoczek_array,kwh_iloscwyk_array
    INTO kkwrec FROM tr_kkwhead 
    WHERE kwh_idheadu=NEW.kwh_idheadu;
    _iloscplanwyk=kkwrec.kwh_iloscoczek;
    _iloscwyk=kkwrec.kwh_iloscwmag;
    _iloscplanwyk_array=kkwrec.kwh_iloscoczek_array;
    _iloscwyk_array=kkwrec.kwh_iloscwyk_array;
   END IF;
   
   IF ((NEW.knr_flaga&(1<<12))=(1<<12)) THEN -- dla rozmiarowki
    _wystepowanie_array=(SELECT knrr_rozmiarwyst FROM tr_nodrecrozmiarowka WHERE knr_idelemu=NEW.knr_idelemu);
    NEW.knr_iloscplan=array_sum(KKWNODObliczIlosc_ARRAY(_iloscplanwyk_array,NULL,_wystepowanie_array,NEW.knr_licznik,NEW.knr_mianownik,NEW.trr_flaga,NEW.knr_flaga,0));
    NEW.knr_iloscwyk=array_sum(KKWNODObliczIlosc_ARRAY(_iloscwyk_array,NULL,_wystepowanie_array,NEW.knr_licznik,NEW.knr_mianownik,NEW.trr_flaga,NEW.knr_flaga,0));
   ELSE -- dla zwyklych   
    IF ((NEW.trr_flaga&4)=0) THEN
     NEW.knr_iloscplan=max(KKWNODobliczilosc(_iloscplanwyk,_iloscplanbrak,NEW.knr_licznik,NEW.knr_mianownik,NEW.trr_flaga,NEW.knr_flaga),NEW.knr_iloscmin);
     NEW.knr_iloscwyk=max(KKWNODobliczilosc(_iloscwyk,_iloscbrakow,NEW.knr_licznik,NEW.knr_mianownik,NEW.trr_flaga,NEW.knr_flaga),NEW.knr_iloscmin);
    END IF;   
    IF ((NEW.trr_flaga&4)=4) THEN
     NEW.knr_iloscplan=max(KKWNODobliczilosc(_iloscplanstart,0,NEW.knr_licznik,NEW.knr_mianownik,NEW.trr_flaga,NEW.knr_flaga),NEW.knr_iloscmin);
     NEW.knr_iloscwyk=max(KKWNODobliczilosc(_iloscstart,0,NEW.knr_licznik,NEW.knr_mianownik,NEW.trr_flaga,NEW.knr_flaga),NEW.knr_iloscmin);
    END IF;
   END IF;
   
   IF (NEW.knr_iloscrozch>NEW.knr_iloscplan) THEN
    RAISE EXCEPTION '0|Nie mozna zmienic ilosci (ilosc rozchodowana przewyzsza ilosc planowana ';
   END IF;
   ---koniec przeliczania nowych ilosci 
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (COALESCE(NEW.tmg_idmagazynu,0)<>COALESCE(OLD.tmg_idmagazynu,0) OR COALESCE(NEW.ttw_idtowaru,0)<>COALESCE(OLD.ttw_idtowaru,0)) THEN
   IF (NEW.knr_iloscrozch<>0) THEN
    RAISE EXCEPTION 'Nie mozna zmieniac magazynu ani surowca przy wygenerowanych rozchodach!';
   END IF;
  END IF;

  IF (NEW.knr_flaga&16=16) THEN
   IF (NEW.knr_iloscrozch<>0) THEN
    RAISE EXCEPTION '8|%:%|Nie mozna anulowac ',NEW.kwe_idelemu,NEW.knr_iloscrozch;
   END IF;
  END IF;
 END IF;

 IF (TG_OP='INSERT' OR TG_OP='UPDATE') THEN  
  IF (NEW.knr_flaga&3<>0) THEN
   NEW.knr_flaga=NEW.knr_flaga|4;
  ELSE
   NEW.knr_flaga=NEW.knr_flaga&(~4);
  END IF;
 END IF;
 
 ------------------------------------------------------------------------------
 ----- BACKORDERY - START
 ------------------------------------------------------------------------------
 IF (TG_OP='INSERT') THEN
  deltabonew=max(NEW.knr_iloscplan-NEW.knr_iloscrozch,0);
  ---Wyzeruj backorder jesli zamkniete jest KKW  
  IF (NEW.knr_flaga&4=4) THEN 
   deltabonew=0; 
  END IF;
  
  IF (NEW.knr_wplywmag=1) THEN 
   flaga_backorder=1; ----backorder plusowy
  END IF;
  IF (NEW.knr_wplywmag=-1) THEN 
   flaga_backorder=0;  ----backorder minusowy  
  END IF;
  
  IF (NEW.knr_wplywmag<>0) THEN ---- Dla narzedzi nie robie
   PERFORM DodajBackOrderNodRec(NEW.knr_idelemu,NEW.ttm_idtowmag,deltabonew,3,flaga_backorder,_data,(SELECT zl_idzlecenia FROM tr_kkwhead AS kkw WHERE kkw.kwh_idheadu=NEW.kwh_idheadu),NEW.knr_flaga,NEW.tmg_idmagazynu);  
  END IF;  
 END IF;
 
 IF (TG_OP='UPDATE') THEN
  deltabonew=max(NEW.knr_iloscplan-NEW.knr_iloscrozch,0);
  deltaboold=max(OLD.knr_iloscplan-OLD.knr_iloscrozch,0);
  ---Wyzeruj backorder jesli zamkniete jest KKW  
  IF (NEW.knr_flaga&4=4) THEN
   deltabonew=0; 
  END IF;
  
  IF (NEW.knr_wplywmag=1) THEN 
   flaga_backorder=1; ----backorder plusowy
   _data=(SELECT coalesce(kwh_dataplanstop,kwh_datazak)::date FROM tr_kkwhead WHERE kwh_idheadu=NEW.kwh_idheadu); ---dla plusowego po zakonczeniu
  END IF;
  IF (NEW.knr_wplywmag=-1) THEN 
   flaga_backorder=0;  ----backorder minusowy  
   _data=(SELECT coalesce(kwh_dataplanstart,kwh_datarozp)::date FROM tr_kkwhead WHERE kwh_idheadu=NEW.kwh_idheadu); --- dla minusowego przy rozpoczeciu
  END IF;
    
  IF (NEW.knr_wplywmag<>0) THEN ---- Dla narzedzi nie robie
   IF (COALESCE(NEW.ttm_idtowmag,0)<>COALESCE(OLD.ttm_idtowmag,0)) THEN -- Zmienilem towar/magazyn
    PERFORM DodajBackOrderNodRec(OLD.knr_idelemu,OLD.ttm_idtowmag,0,3,flaga_backorder,_data,(SELECT zl_idzlecenia FROM tr_kkwhead AS kkw WHERE kkw.kwh_idheadu=OLD.kwh_idheadu),OLD.knr_flaga,OLD.tmg_idmagazynu);
    PERFORM DodajBackOrderNodRec(NEW.knr_idelemu,NEW.ttm_idtowmag,deltabonew,3,flaga_backorder,_data,(SELECT zl_idzlecenia FROM tr_kkwhead AS kkw WHERE kkw.kwh_idheadu=NEW.kwh_idheadu),NEW.knr_flaga,NEW.tmg_idmagazynu); 
   ELSE
    IF (deltabonew<>deltaboold) THEN
     PERFORM DodajBackOrderNodRec(NEW.knr_idelemu,NEW.ttm_idtowmag,deltabonew,3,flaga_backorder,_data,(SELECT zl_idzlecenia FROM tr_kkwhead AS kkw WHERE kkw.kwh_idheadu=NEW.kwh_idheadu),NEW.knr_flaga,NEW.tmg_idmagazynu); 
    END IF;  
   END IF;
  END IF;
 END IF;
 
 IF (TG_OP='DELETE') THEN  
 
  IF (OLD.knr_wplywmag=1) THEN 
   flaga_backorder=1; ----backorder plusowy
  END IF;
  IF (OLD.knr_wplywmag=-1) THEN 
   flaga_backorder=0;  ----backorder minusowy  
  END IF;
  
  IF (OLD.knr_wplywmag<>0) THEN ---- Dla narzedzi nie robie
   PERFORM DodajBackOrderNodRec(OLD.knr_idelemu,OLD.ttm_idtowmag,0,3,flaga_backorder,_data,(SELECT zl_idzlecenia FROM tr_kkwhead AS kkw WHERE kkw.kwh_idheadu=OLD.kwh_idheadu),OLD.knr_flaga,OLD.tmg_idmagazynu);
  END IF;
 END IF;
 
 ------------------------------------------------------------------------------
 ----- BACKORDERY - KONIEC
 ------------------------------------------------------------------------------

 IF (TG_OP='UPDATE') THEN
  IF (
      (OLD.knr_licznik!=NEW.knr_licznik) OR 
      (OLD.knr_mianownik!=NEW.knr_mianownik) OR
      (OLD.knr_iloscplan!=NEW.knr_iloscplan) OR
      (OLD.knr_iloscwyk!=NEW.knr_iloscwyk) OR
      (OLD.knr_iloscrozch!=NEW.knr_iloscrozch)
     )
  THEN
   ---kwestie skojarzenia nodreca z planem zlecenia
   IF (NEW.knr_wplywmag=1) THEN 
    deltaplan_roz=NEW.knr_iloscplan-OLD.knr_iloscplan;
    deltaplan_wyk=NEW.knr_iloscrozch-OLD.knr_iloscrozch;
    ---korekta o nadmiar/niedomiar z czesniejszych operacji
    RAISE NOTICE 'Korekta ,%, %, %',deltaplan_roz,OLD.knr_iloscplan,OLD.knr_ilosc_plan_rozplan; 
    deltaplan_roz=deltaplan_roz+(OLD.knr_iloscplan-OLD.knr_ilosc_plan_rozplan);
    deltaplan_wyk=deltaplan_wyk+(OLD.knr_iloscrozch-OLD.knr_iloscrozch);
   END IF;
   
   ---komunikat sprawdzajacy poprawnosc dzialania
   RAISE NOTICE ':INVO: 157,%, %, %',NEW.knr_idelemu,deltaplan_roz,deltaplan_wyk; 
  END IF;
 END IF;

 IF (deltaplan_roz<>0) THEN
  NEW.knr_ilosc_plan_rozplan=NEW.knr_ilosc_plan_rozplan+zmienPowiazanieNodRecPlanZlecenia(NEW.knr_idelemu,deltaplan_roz,NEW.ttw_idtowaru,(SELECT zl_idzlecenia FROM tr_kkwhead WHERE kwh_idheadu=NEW.kwh_idheadu),NEW.knr_flaga);
 END IF;
  
 IF (deltaplan_wyk<>0) THEN
  NEW.knr_ilosc_plan_wyk=NEW.knr_ilosc_plan_wyk+zmienWykonanieNodRecPlanZlecenia(NEW.knr_idelemu,deltaplan_wyk);
 END IF;

 IF (TG_OP='INSERT' OR TG_OP='UPDATE') THEN  
  IF ((NEW.knr_flaga&(1<<12))=0) THEN -- nie dla rozmiarowki
   NEW.knr_iloscplan=max(NEW.knr_iloscplan,NEW.knr_iloscmin);
   NEW.knr_iloscwyk=max(NEW.knr_iloscwyk,NEW.knr_iloscmin);
  END IF;
 END IF;
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
