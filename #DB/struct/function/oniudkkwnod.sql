CREATE FUNCTION oniudkkwnod() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltamold NUMERIC:=0;
 deltamnew NUMERIC:=0;
 deltamcold NUMERIC:=0;
 deltamcnew NUMERIC:=0;

 deltasold NUMERIC:=0;
 deltasnew NUMERIC:=0;

 _kwe_idprev INT:=0;
---flaga o ktora zmieniamy flege naglowka (np o rozpoczeciu wykonania czy planowania
 kkwflaga_add INT:=0; 
 kkwflaga_del INT:=0;
 tmp INT:=0;
 vth_flaga INT:=0;
 rec RECORD;
 rec_kkw RECORD;
BEGIN
 
 IF (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
  NEW.kwe_dataostmod=now();
 END IF;
 
 ---pobieramy normatyw dla wykonania tej operacji, jesli normatyw ustalany na technologii
 IF (TG_OP='INSERT') THEN
  SELECT kkw.th_flaga AS flaga, kkw.kwh_datarozp AS datarozp INTO rec_kkw FROM tr_kkwhead AS kkw WHERE kwh_idheadu=NEW.kwh_idheadu;
  NEW.kwe_datazakonczenia_prev=rec_kkw.datarozp;
  vth_flaga=rec_kkw.flaga;
  IF (vth_flaga&16=0 AND NEW.the_idelem>0) THEN
   --normatyw z technologii, przenosimy wed.ug stanowiska domyslnego
   SELECT COALESCE(tsp_tpz,the_tpz) AS the_tpz,COALESCE(tsp_tpj,the_tpj) AS the_tpj,  COALESCE(tsp_wydajnosc,the_wydajnosc) AS the_wydajnosc, COALESCE(tsp_iloscosob,the_iloscosob) AS the_iloscosob, COALESCE(tsp_kosztnah,the_kosztnah) AS the_kosztnah, COALESCE(tsp_kosztnaj,the_kosztnaj) AS the_kosztnaj, COALESCE(tsp_zaangazpracownika,the_zaangazpracownika) AS the_zaangazpracownika, COALESCE(tsp_koopczasreal,the_koopczasreal) AS the_koopczasreal INTO rec FROM tr_technoelem AS te LEFT JOIN tr_technostpracy AS tsp ON (te.the_idelem=tsp.the_idelem AND tsp.tsp_flaga&2=2) WHERE te.the_idelem=NEW.the_idelem LIMIT 1;
   NEW.kwe_tpz=rec.the_tpz;
   NEW.kwe_tpj=rec.the_tpj;
   NEW.kwe_wydajnosc=rec.the_wydajnosc;
   NEW.kwe_iloscosob=rec.the_iloscosob;
   NEW.kwe_kosztnah=rec.the_kosztnah;
   NEW.kwe_kosztnaj=rec.the_kosztnaj;
   NEW.kwe_zaangazpracownika=rec.the_zaangazpracownika;
   NEW.kwe_koopczasreal=rec.the_koopczasreal;
  END IF;
 END IF;

 IF (TG_OP<>'INSERT') THEN
  deltamold=deltamold-OLD.kwe_tomagmag;
  deltamcold=deltamcold-OLD.kwe_tomagmagclosed;
  IF (OLD.kwe_flaga&2048=0) THEN
   deltasold=deltasold-OLD.kwe_iloscstart;
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  ---wyliczamy nowe ilosci wykonania lub wykonania procentowo
  IF (NEW.the_flaga&8192=8192) THEN
  ---rejestracja procentowo, sprawdzamy czy wykonane jest 100% jesli tak to ustawiamy ilosc wykonana na ilosc do wykonania
   IF (NEW.kwe_iloscwykprocent>=100) THEN
    NEW.kwe_iloscwyk=NEW.kwe_iloscplanwyk;
   ELSE
    NEW.kwe_iloscwyk=0;
   END IF;
   IF (NEW.kwe_iloscrozplanowanaprocent>=100) THEN
    NEW.kwe_iloscrozplanowana=NEW.kwe_iloscplanwyk;
   ELSE
    NEW.kwe_iloscrozplanowana=0;
   END IF;
  ELSE --wykonanie ilosciowe, przeliczam procent
   IF (NEW.kwe_iloscplanwyk>0) THEN
    NEW.kwe_iloscwykprocent=round(100*NEW.kwe_iloscwyk/NEW.kwe_iloscplanwyk,2);
    NEW.kwe_iloscrozplanowanaprocent=round(100*NEW.kwe_iloscrozplanowana/NEW.kwe_iloscplanwyk,2);
   END IF;
  END IF;

  NEW.kwe_tomag=round(NEW.kwe_tomagmag*NEW.kwe_mnoznikwyrobu_l/NEW.kwe_mnoznikwyrobu_m,0);

  IF ((NEW.the_flaga&512)=0) THEN
   NEW.kwe_iloscstart=NEW.kwe_iloscwyk+NEW.kwe_iloscbrakow;
  END IF;
  NEW.kwe_iloscplanstart=NEW.kwe_iloscplanwyk+NEW.kwe_iloscplanbrak;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  deltamnew=deltamnew+NEW.kwe_tomagmag;
  deltamcnew=deltamcnew+NEW.kwe_tomagmagclosed;
  IF (NEW.kwe_flaga&2048=0) THEN
   deltasnew=deltasnew+NEW.kwe_iloscstart;
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN

  deltamnew=deltamnew+deltamold;
  deltamold=0;
  deltamcnew=deltamcnew+deltamcold;
  deltamcold=0;
  deltasnew=deltasnew+deltasold;
  deltasold=0;

  ---Sprawdz czy dobrze przenosze na magazyn
  IF (OLD.kwe_tomagmag<>NEW.kwe_tomagmag) THEN
   IF (NEW.the_flaga&4096=4096) AND (NEW.kwe_flaga&64=0) THEN
    RAISE EXCEPTION '11|%|Zle przeniesiono na magazyn',NEW.kwe_idelemu;
   END IF;
   IF (NEW.the_flaga&4096=0) AND (NEW.kwe_flaga&64=64) THEN
    RAISE EXCEPTION '11|%|Zle przeniesiono na magazyn',NEW.kwe_idelemu;
   END IF;
  END IF;

   NEW.kwe_flaga=NEW.kwe_flaga&(~64); 

 END IF;

 IF (deltasold<>0) THEN
  UPDATE tr_kkwnodprevnext SET knpn_fromnext=knpn_fromnext+deltasold WHERE kwe_idnext=OLD.kwe_idelemu;
 END IF;

 IF (deltasnew<>0) THEN
  IF (TG_OP='INSERT') THEN
   RAISE EXCEPTION 'Blad ilosci brakow/dobrych przy konstrukcji KKW';
  END IF;
  UPDATE tr_kkwnodprevnext SET knpn_fromnext=knpn_fromnext+deltasnew WHERE kwe_idnext=NEW.kwe_idelemu;
 END IF;


IF (TG_OP='UPDATE') THEN
  -- Sprawdzenie warunkow
  IF (NEW.kwe_flaga&2048=2048) THEN
   IF (
       (NEW.kwe_tomag<>0) OR 
       (NEW.kwe_iloscwyk<>0) OR
       (NEW.kwe_iloscbrakow<>0) OR
       (NEW.kwe_flaga&(8+16)<>0)
      )
   THEN
    RAISE EXCEPTION '7|%:%:%:%|Nie mozna anulowac ',NEW.kwe_idelemu,NEW.kwe_tomag,NEW.kwe_iloscwyk,NEW.kwe_iloscbrakow;
   END IF;
  END IF;

--  IF ((NEW.kwe_flaga&2048)<>(OLD.kwe_flaga&2048)) THEN
--   UPDATE tr_nodrec SET knr_flaga=flagMask(knr_flaga,16,((NEW.kwe_flaga&2048)<>0)) WHERE kwe_idelemu=NEW.kwe_idelemu;   
--   PERFORM zmienAktywnoscPrevNext(NEW.kwe_idelemu,((NEW.kwe_flaga&2048)=0));
--  END IF;

  ---zmiana ilosci planowanej - przenosimy ja na poprzedniki
  IF ((NEW.kwe_iloscplanwyk+NEW.kwe_iloscplanbrak)<>(OLD.kwe_iloscplanwyk+OLD.kwe_iloscplanbrak)) THEN
   UPDATE tr_kkwnodprevnext SET knpn_kweilosc=(NEW.kwe_iloscplanwyk+NEW.kwe_iloscplanbrak) WHERE kwe_idnext=NEW.kwe_idelemu;
  END IF;
    
 END IF;

 IF (deltamold<>0 OR deltamcold<>0) THEN
  UPDATE tr_kkwhead SET kwh_iloscwmag=kwh_iloscwmag+deltamold,kwh_iloscwmagclosed=kwh_iloscwmagclosed+deltamcold WHERE kwh_idheadu=OLD.kwh_idheadu;
 END IF;

 IF (deltamnew<>0 OR deltamcnew<>0) THEN
  UPDATE tr_kkwhead SET kwh_iloscwmag=kwh_iloscwmag+deltamnew,kwh_iloscwmagclosed=kwh_iloscwmagclosed+deltamcnew WHERE kwh_idheadu=NEW.kwh_idheadu;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  ---informacja o przekazaniu wszystkiego
  NEW.kwe_flaga=flagMask(NEW.kwe_flaga,2,(NEW.kwe_iloscwyk<NEW.kwe_tonext));
  ---infarmacja o wykonaniu wszystkiego
  NEW.kwe_flaga=flagMask(NEW.kwe_flaga,32,(NEW.kwe_iloscwyk>=NEW.kwe_iloscplanwyk));
  ---informacja o rozplanowaniu wszystkiego, tylko wowczas gdy jest ustawiona flaga o planach
  IF (NEW.kwe_flaga&8=8) THEN
   NEW.kwe_flaga=flagMask(NEW.kwe_flaga,128,(NEW.kwe_iloscrozplanowana>=NEW.kwe_iloscplanwyk));
  ELSE
   NEW.kwe_flaga=flagMask(NEW.kwe_flaga,128,FALSE);
  END IF;
  ----informacja o ropoczetym wykonaniu dla kooperacji
  IF (NEW.kwe_nodtype=1) THEN
   IF ((NEW.kwe_iloscwyk>0) OR (NEW.kwe_iloscstart>0)) THEN
    NEW.kwe_flaga=flagMask(NEW.kwe_flaga,16,true);
   ELSE 
    NEW.kwe_flaga=flagMask(NEW.kwe_flaga,16,false);
   END IF;
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
 ---sprawdzamy czy mamy przenosic pewne informacje na naglowek kkw (o planowaniu czy wykonaniu)
  ---odnosnie rozoczecia planowania
  IF ((NEW.kwe_flaga&8)=8 AND (OLD.kwe_flaga&8)=0) THEN
   kkwflaga_add=kkwflaga_add|8;
  END IF;
  IF ((NEW.kwe_flaga&8)=0 AND (OLD.kwe_flaga&8)=8) THEN
   ---byl choc jeden plan ale zostal skasowany
   tmp=(SELECT count(*) FROM tr_kkwnod WHERE kwh_idheadu=NEW.kwh_idheadu AND kwe_idelemu<>NEW.kwe_idelemu AND kwe_flaga&8=8 AND kwe_flaga&2048=0);
   IF (tmp=0) THEN
    UPDATE tr_kkwhead SET kwh_flaga=kwh_flaga&(~8) WHERE kwh_idheadu=NEW.kwh_idheadu;
   END IF;
  END IF;
  ---odnosnie rozoczecia wykonania
  IF ((NEW.kwe_flaga&16)=16 AND (OLD.kwe_flaga&16)=0) THEN
   kkwflaga_add=kkwflaga_add|16;
  END IF;
  IF ((NEW.kwe_flaga&16)=0 AND (OLD.kwe_flaga&16)=16) THEN
   ---byl choc jedno wykonanie ale zostalo skasowane
   tmp=(SELECT count(*) FROM tr_kkwnod WHERE kwh_idheadu=NEW.kwh_idheadu AND kwe_idelemu<>NEW.kwe_idelemu AND kwe_flaga&16=16 AND kwe_flaga&2048=0);
   IF (tmp=0) THEN
    UPDATE tr_kkwhead SET kwh_flaga=kwh_flaga&(~16) WHERE kwh_idheadu=NEW.kwh_idheadu;
   END IF;
  END IF;
  ---odnosnie calkowitego wykonania
  IF ((NEW.kwe_flaga&32)=32 AND (OLD.kwe_flaga&32)=0) THEN
   ---ten nod wykonany sprawdzamy czy sa jakies niewykonane
   tmp=(SELECT count(*) FROM tr_kkwnod WHERE kwh_idheadu=NEW.kwh_idheadu AND kwe_idelemu<>NEW.kwe_idelemu AND kwe_flaga&32=0 AND kwe_flaga&2048=0);
   IF (tmp=0) THEN
    UPDATE tr_kkwhead SET kwh_flaga=kwh_flaga|(32) WHERE kwh_idheadu=NEW.kwh_idheadu;
   END IF;
  END IF;
  IF ((NEW.kwe_flaga&32)=0 AND (OLD.kwe_flaga&32)=32) THEN
   kkwflaga_del=kkwflaga_del|32;
  END IF;
    ---odnosnie calkowitego rozplanowania
  IF ((NEW.kwe_flaga&128)=128 AND (OLD.kwe_flaga&128)=0) THEN
   ---ten nod rozplanowany sprawdzamy czy sa jakies niewykonane
   tmp=(SELECT count(*) FROM tr_kkwnod WHERE kwh_idheadu=NEW.kwh_idheadu AND kwe_idelemu<>NEW.kwe_idelemu AND kwe_flaga&128=0 AND kwe_flaga&2048=0);
   IF (tmp=0) THEN
    UPDATE tr_kkwhead SET kwh_flaga=kwh_flaga|(64) WHERE kwh_idheadu=NEW.kwh_idheadu;
   END IF;
  END IF;
  IF ((NEW.kwe_flaga&128)=0 AND (OLD.kwe_flaga&128)=128) THEN
   kkwflaga_del=kkwflaga_del|64;
  END IF;
 END IF;

 ---uaktualniamy flage na naglowku jesli jest potrzeba
 IF (kkwflaga_add<>0 OR kkwflaga_del<>0) THEN
  UPDATE tr_kkwhead SET kwh_flaga=(kwh_flaga|kkwflaga_add)&(~kkwflaga_del) WHERE kwh_idheadu=NEW.kwh_idheadu;
 END IF;
   
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
