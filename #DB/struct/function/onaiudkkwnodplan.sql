CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 tmp INT;
 liczymykubelkiold BOOL:=FALSE;
 liczymykubelkinew BOOL:=FALSE;
 przeliczamydateKKWstart BOOL:=FALSE;
 przeliczamydateKKWstop BOOL:=FALSE;
BEGIN
 RAISE NOTICE 'Robie onaiudkkwnodplan()';
 -------------------------------------------------------------------------------------------------------------
 -----czesc odnosnie planow kubelkowych
 IF (TG_OP='UPDATE') THEN
  ---dla planow kubelkowych, uaktualnienie czy sa plany do danego kubelka
  IF (OLD.knp_flaga&32=0 AND NEW.knp_flaga&32=32) THEN
   liczymykubelkinew=TRUE;
  END IF;
  IF (OLD.knp_flaga&32=32 AND NEW.knp_flaga&32=0) THEN
   liczymykubelkiold=TRUE;
  END IF;
  IF (OLD.knp_flaga&32=32 AND NEW.knp_flaga&32=32 AND OLD.kb_idkubelka<>NEW.kb_idkubelka) THEN
   liczymykubelkiold=TRUE;
   liczymykubelkinew=TRUE;
  END IF;
 END IF;

 IF (TG_OP='INSERT') THEN
  IF (NEW.knp_flaga&32=32) THEN
   liczymykubelkinew=TRUE;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  IF (OLD.knp_flaga&32=32) THEN
   liczymykubelkiold=TRUE;
  END IF;
 END IF;

 IF (liczymykubelkinew) THEN
 ---zaznaczamy ze kubelek po NEW ma plan
  UPDATE tr_kubelki SET kb_flaga=kb_flaga|(1) WHERE kb_idkubelka=NEW.kb_idkubelka;
 END IF;

 IF (liczymykubelkiold) THEN
 ---liczymy kubelki po OLD czy maja jakies inne plany
  tmp=(SELECT count(*) FROM tr_kkwnodplan WHERE kb_idkubelka=OLD.kb_idkubelka AND knp_idplanu<>OLD.knp_idplanu);

  IF (tmp=0) THEN
   UPDATE tr_kubelki SET kb_flaga=kb_flaga&(~1) WHERE kb_idkubelka=OLD.kb_idkubelka;
  END IF;
 END IF;
 -----koniec czesc odnosnie planow kubelkowych
 -------------------------------------------------------------------------------------------------------------

 IF (TG_OP='DELETE') THEN
  PERFORM PrzeliczMinMaxDataKKW(OLD.kwh_idheadu);

  -----Jest plan
  tmp=(SELECT count(*) FROM tr_kkwnodplan WHERE kwe_idelemu=OLD.kwe_idelemu AND knp_idplanu<>OLD.knp_idplanu);

  IF (tmp=0) THEN
   UPDATE tr_kkwnod SET kwe_flaga=kwe_flaga&(~8) WHERE kwe_idelemu=OLD.kwe_idelemu;
  END IF;

  ---jak jest status to usuwamy statusy do tego planu
  IF (OLD.st_idstatusu>0) THEN
   DELETE FROM tg_statusyhistoria WHERE sh_type=162 AND sh_idref=OLD.knp_idplanu;
  END IF;  
 END IF;
  
 ---liczymy czas wolny (niepracujecy) w okresie planu
 IF (TG_OP<>'DELETE') THEN 
  RAISE NOTICE 'liczymy czas wolny (niepracujecy) w okresie planu'; 
  ---tylko dla planow niewykonanych i aktywnych
  IF (NEW.knp_flaga&(1|2|16)=0) THEN
   ---gdy jest stanowisko (nie grupa maszyn) czas wolny liczymy 
   IF (NEW.ob_idobiektu>0 AND NEW.knp_flaga&32=0) THEN
    NEW.knp_czaswolny=getfreetime(NEW.knp_datarozpoczecia, NEW.knp_datazakonczenia, NEW.ob_idobiektu, 1);
	NEW.knp_czaswolny_np=getfreetime(NEW.knp_datarozpoczecia, NEW.knp_datazakonczenia, NEW.ob_idobiektu, 2);
   ELSE
   ---niema stanowiska zerujemy czas wolny
    NEW.knp_czaswolny=0;
	NEW.knp_czaswolny_np=0;
   END IF;
  END IF;
 END IF;
 ---koniec liczenie czasu wolnego

 ----------------------------------------------------------------------------------------------------------
 ---Odnosnie przenoszenia dat na KKW
 ----------------------------------------------------------------------------------------------------------
 IF (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
  IF ((NEW.knp_flaga&(1<<15))<>(1<<15)) THEN
   IF (TG_OP='INSERT') THEN
    przeliczamydateKKWstart=TRUE;
    przeliczamydateKKWstop=TRUE;
   END IF;
   
   IF (TG_OP='UPDATE') THEN
    IF (NEW.knp_datarozpoczecia<>OLD.knp_datarozpoczecia) THEN
     przeliczamydateKKWstart=TRUE;
    END IF;
    IF (NEW.knp_datazakonczenia<>OLD.knp_datazakonczenia) THEN
     przeliczamydateKKWstop=TRUE;
    END IF;
   END IF;
   
   IF (przeliczamydateKKWstart OR przeliczamydateKKWstop) THEN ---zmienily sie daty planu wiec musimy przeliczyc date minmax na nodach
    PERFORM PrzeliczMinMaxDataKKW(NEW.kwh_idheadu);
   END IF;
   
   IF (przeliczamydateKKWstart) THEN
    UPDATE tr_kkwhead SET kwh_dataplanstart=(SELECT min(knp_datarozpoczecia) FROM tr_kkwnodplan WHERE tr_kkwnodplan.kwh_idheadu=tr_kkwhead.kwh_idheadu) WHERE kwh_flaga&64=64 AND kwh_idheadu=NEW.kwh_idheadu;
   END IF;
   
   IF (przeliczamydateKKWstop) THEN
    UPDATE tr_kkwhead SET kwh_dataplanstop=(SELECT max(knp_datazakonczenia) FROM tr_kkwnodplan WHERE tr_kkwnodplan.kwh_idheadu=tr_kkwhead.kwh_idheadu) WHERE kwh_flaga&64=64 AND kwh_idheadu=NEW.kwh_idheadu;
   END IF;
   
  END IF;
 END IF;
 ----------------------------------------------------------------------------------------------------------
 ---Koniec odnosnie przenoszenia dat na KKW
 ----------------------------------------------------------------------------------------------------------
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
