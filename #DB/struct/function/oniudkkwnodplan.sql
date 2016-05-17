CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltaplanold NUMERIC:=0;
 deltaplannew NUMERIC:=0;
 deltarbhkubelekold NUMERIC:=0;
 deltarbhkubeleknew NUMERIC:=0;
 r RECORD;
 tmp NUMERIC:=0;
BEGIN

 IF (TG_OP<>'DELETE') THEN
 ---sprawdzamy czy mamy wywolywac trigery
  IF (NEW.knp_flaga&16384=16384) THEN
   --zerujemy flage do niewywolywania trigerow i wychodzimy
   NEW.knp_flaga=NEW.knp_flaga&(~16384);
   RETURN NEW;
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
 ---ustawiamy flagi na wykonanie planu
  NEW.knp_flaga=flagMask(NEW.knp_flaga,8,(NEW.knp_iloscwykonana>0));
  NEW.knp_flaga=flagMask(NEW.knp_flaga,16,(NEW.knp_iloscwykonana>=NEW.knp_iloscplanowana));
 END IF; 

 ---liczymy norme dla tego planu
 IF (TG_OP<>'DELETE') THEN 
  ---tylko dla planow niewykonanych i aktywnych
  IF (NEW.knp_flaga&(1|2|16)=0) THEN
  ---pobieramy ilosc dla ktorej liczymy norme
   tmp=NEW.knp_iloscplanowana-NEW.knp_iloscwykonana;
   IF (NEW.knp_flaga&128=128) THEN
    --plan procentowy, musimy przeliczyc ilosc wedlug procentow
    tmp=Round(tmp*(SELECT kwe_iloscplanwyk FROM tr_kkwnod WHERE kwe_idelemu=NEW.kwe_idelemu)/100,4);
   END IF;
   --uaktualniamy czas wedlug normy
   NEW.knp_czasnormapozostalo=getSzacowanyCzasPracyNetto(max(tmp,0),NEW.ob_idobiektu, NEW.kwe_idelemu);
  ELSE 
   NEW.knp_czasnormapozostalo=0;
  END IF;
 END IF;
 ---koniec liczenie czasu wolnego

 IF (TG_OP='INSERT') THEN
  SELECT kwh_idheadu,kwe_flaga INTO r FROM tr_kkwnod WHERE kwe_idelemu=NEW.kwe_idelemu;
  NEW.kwh_idheadu=r.kwh_idheadu;
  NEW.knp_flaga=flagMask(NEW.knp_flaga,1,(((r.kwe_flaga>>11)&1)=1));
 END IF;

 IF (TG_OP<>'INSERT') THEN
  IF (OLD.knp_flaga&2=2) THEN --- Plan wykonany
    deltaplanold=deltaplanold-OLD.knp_iloscwykonana;
  ELSE
   deltaplanold=deltaplanold-max(OLD.knp_iloscplanowana,OLD.knp_iloscwykonana);
  END IF;

  IF (OLD.knp_flaga&32=32) THEN
  ---plan kubelkowy
   deltarbhkubelekold=deltarbhkubelekold-(Round(OLD.knp_czasnormapozostalo/60,2));
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  IF (NEW.knp_flaga&2=2) THEN
   ---plan oznaczony jako wykonany (zamkniety) liczymy ilosc wykonana
   deltaplannew=deltaplannew+NEW.knp_iloscwykonana;
  ELSE 
   deltaplannew=deltaplannew+max(NEW.knp_iloscplanowana,NEW.knp_iloscwykonana);
  END IF;

  IF (NEW.knp_flaga&32=32) THEN
  ---plan kubelkowy
   deltarbhkubeleknew=deltarbhkubeleknew+(Round(NEW.knp_czasnormapozostalo/60,2));
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NEW.kwe_idelemu=OLD.kwe_idelemu) THEN
   deltaplannew=deltaplannew+deltaplanold;
   deltaplanold=0;
  END IF;

  IF (NEW.kb_idkubelka=OLD.kb_idkubelka AND NEW.knp_flaga&32=32 AND OLD.knp_flaga&32=32) THEN
   deltarbhkubeleknew=deltarbhkubeleknew+deltarbhkubelekold;
   deltarbhkubelekold=0;
  END IF;
 END IF;

 ----zmiany na kubelkach
 IF (deltarbhkubeleknew<>0 ) THEN
  UPDATE tr_kubelki SET kb_pojemnoscroz=kb_pojemnoscroz+deltarbhkubeleknew WHERE kb_idkubelka=NEW.kb_idkubelka;
 END IF;

 IF (deltarbhkubelekold<>0 ) THEN
  UPDATE tr_kubelki SET kb_pojemnoscroz=kb_pojemnoscroz+deltarbhkubelekold WHERE kb_idkubelka=OLD.kb_idkubelka;
 END IF;

 ----zmiany na nodach
 IF (deltaplanold<>0 ) THEN
  IF (OLD.knp_flaga&128=128) THEN
  --plan procentowy
   UPDATE tr_kkwnod SET kwe_iloscrozplanowanaprocent=kwe_iloscrozplanowanaprocent+deltaplanold WHERE kwe_idelemu=OLD.kwe_idelemu;
  ELSE --plan ilosciowy
   UPDATE tr_kkwnod SET kwe_iloscrozplanowana=kwe_iloscrozplanowana+deltaplanold WHERE kwe_idelemu=OLD.kwe_idelemu;
  END IF;
 END IF;

 IF (deltaplannew<>0) OR (TG_OP='INSERT') THEN
  IF (NEW.knp_flaga&128=128) THEN
  --plan procentowy
   UPDATE tr_kkwnod SET kwe_iloscrozplanowanaprocent=kwe_iloscrozplanowanaprocent+deltaplannew,kwe_flaga=kwe_flaga|8 WHERE kwe_idelemu=NEW.kwe_idelemu;
  ELSE --plan ilosciowy
   UPDATE tr_kkwnod SET kwe_iloscrozplanowana=kwe_iloscrozplanowana+deltaplannew,kwe_flaga=kwe_flaga|8 WHERE kwe_idelemu=NEW.kwe_idelemu;
  END IF;
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
