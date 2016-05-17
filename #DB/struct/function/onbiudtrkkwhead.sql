CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltaplold NUMERIC:=0;
 deltaplnew NUMERIC:=0;
 deltawykold NUMERIC:=0;
 deltawyknew NUMERIC:=0;
 deltawykcold NUMERIC:=0;
 deltawykcnew NUMERIC:=0;
 zmiana_prorytetow TEXT;
 typprorytetu INT;
BEGIN

 IF (TG_OP<>'INSERT') THEN
  deltaplold=deltaplold-OLD.kwh_iloscoczek;
  deltawykold=deltawykold-OLD.kwh_iloscwmag;
  deltawykcold=deltawykcold-OLD.kwh_iloscwmagclosed;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  deltaplnew=deltaplnew+NEW.kwh_iloscoczek;
  deltawyknew=deltawyknew+NEW.kwh_iloscwmag;
  deltawykcnew=deltawykcnew+NEW.kwh_iloscwmagclosed;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NEW.pz_idplanu=OLD.pz_idplanu) THEN
   deltaplnew=deltaplnew+deltaplold;
   deltaplold=0;
   deltawyknew=deltawyknew+deltawykold;
   deltawykold=0;
   deltawykcnew=deltawykcnew+deltawykcold;
   deltawykcold=0;
  END IF; ---czesc odnosnie prorytetu
  
  IF (OLD.thg_idgrupy!=NEW.thg_idgrupy AND (NEW.kwh_flaga&3)=0 AND (OLD.kwh_flaga&3)=0) THEN ---jesli prorytet ma cos wspolnego z grupa technologii to aktulane kkw wysylamy na koniec danej kolejki i ewentualnie zmieniamy na innych KKW prorytet
   zmiana_prorytetow=(SELECT cf_defvalue FROM tc_config WHERE cf_tabela='KKW_AUT_ZM_PROR'); ---zmieniamy automatycznie innym prorytet
   typprorytetu=(SELECT cf_defvalue::int FROM tc_config WHERE cf_tabela='KKW_PRORYTET_TYP' LIMIT 1 OFFSET 0);
   IF (typprorytetu=2 OR typprorytetu=3 OR typprorytetu=4) THEN ---cos z grupa zmieniamy proretyty
    IF (typprorytetu=2) THEN ---grupy i kkw
     NEW.kwh_prorytet=(SELECT NullZero(max(kwh_prorytet))+1 FROM tr_kkwhead WHERE fm_idcentrali=NEW.fm_idcentrali AND thg_idgrupy=NEW.thg_idgrupy AND th_rodzaj=NEW.th_rodzaj);
     IF (zmiana_prorytetow='1') THEN
      UPDATE tr_kkwhead SET kwh_prorytet=kwh_prorytet-1 WHERE fm_idcentrali=OLD.fm_idcentrali AND thg_idgrupy=OLD.thg_idgrupy AND kwh_prorytet>OLD.kwh_prorytet  AND th_rodzaj=OLD.th_rodzaj;
     END IF;
    END IF;
    IF (typprorytetu=3 OR typprorytetu=4) THEN ---grupy, kkw i zlecenie
     NEW.kwh_prorytet=(SELECT NullZero(max(kwh_prorytet))+1 FROM tr_kkwhead WHERE fm_idcentrali=NEW.fm_idcentrali AND thg_idgrupy=NEW.thg_idgrupy AND NullZero(zl_idzlecenia)=NullZero(NEW.zl_idzlecenia)  AND th_rodzaj=NEW.th_rodzaj);
     IF (zmiana_prorytetow='1') THEN
      UPDATE tr_kkwhead SET kwh_prorytet=kwh_prorytet-1 WHERE fm_idcentrali=OLD.fm_idcentrali AND thg_idgrupy=OLD.thg_idgrupy AND NullZero(zl_idzlecenia)=NullZero(OLD.zl_idzlecenia) AND kwh_prorytet>OLD.kwh_prorytet  AND th_rodzaj=OLD.th_rodzaj;
     END IF;
    END IF;
   END IF;
  END IF;
  IF ((OLD.kwh_flaga&3)=0 AND (NEW.kwh_flaga&3)!=0) THEN ---zamkniecie KKW, nulujemy prorytet i pobieramy w opcjach czy przeliczac prorytet innych kkw
   zmiana_prorytetow=(SELECT cf_defvalue FROM tc_config WHERE cf_tabela='KKW_AUT_ZM_PROR');
   IF (zmiana_prorytetow='1') THEN ---zmieniamy automatycznie innym prorytet
    typprorytetu=(SELECT cf_defvalue::int FROM tc_config WHERE cf_tabela='KKW_PRORYTET_TYP' LIMIT 1 OFFSET 0);
    IF (typprorytetu=0) THEN ---kkw i zlecenie
     UPDATE tr_kkwhead SET kwh_prorytet=kwh_prorytet-1 WHERE fm_idcentrali=OLD.fm_idcentrali AND NullZero(zl_idzlecenia)=NullZero(OLD.zl_idzlecenia) AND kwh_prorytet>OLD.kwh_prorytet  AND th_rodzaj=OLD.th_rodzaj;
    END IF;
    IF (typprorytetu=1) THEN ---kkw 
     UPDATE tr_kkwhead SET kwh_prorytet=kwh_prorytet-1 WHERE fm_idcentrali=OLD.fm_idcentrali AND kwh_prorytet>OLD.kwh_prorytet  AND th_rodzaj=OLD.th_rodzaj;
    END IF;
    IF (typprorytetu=2) THEN ---grupa tech i kkw
     UPDATE tr_kkwhead SET kwh_prorytet=kwh_prorytet-1 WHERE fm_idcentrali=OLD.fm_idcentrali AND thg_idgrupy=OLD.thg_idgrupy AND kwh_prorytet>OLD.kwh_prorytet  AND th_rodzaj=OLD.th_rodzaj;
    END IF;
    IF (typprorytetu=3 OR typprorytetu=4) THEN ---grupa, kkw i zlecenie
     UPDATE tr_kkwhead SET kwh_prorytet=kwh_prorytet-1 WHERE fm_idcentrali=OLD.fm_idcentrali AND thg_idgrupy=OLD.thg_idgrupy AND NullZero(zl_idzlecenia)=NullZero(OLD.zl_idzlecenia) AND kwh_prorytet>OLD.kwh_prorytet  AND th_rodzaj=OLD.th_rodzaj;
    END IF;
   END IF;
   NEW.kwh_prorytet=NULL; ---jest wykonanie anulujemy prorytet
  END IF;
  
  IF ((OLD.kwh_flaga&3)!=0 AND (NEW.kwh_flaga&3)=0) THEN ---przy otwarciu prorytet na koniec kolejki
   typprorytetu=(SELECT cf_defvalue::int FROM tc_config WHERE cf_tabela='KKW_PRORYTET_TYP' LIMIT 1 OFFSET 0);
   IF (typprorytetu=0) THEN ---kkw i zlecenie
    NEW.kwh_prorytet=(SELECT NullZero(max(kwh_prorytet))+1 FROM tr_kkwhead WHERE fm_idcentrali=NEW.fm_idcentrali AND NullZero(zl_idzlecenia)=NullZero(NEW.zl_idzlecenia)  AND th_rodzaj=NEW.th_rodzaj);
   END IF;
   IF (typprorytetu=1) THEN ---kkw
    NEW.kwh_prorytet=(SELECT NullZero(max(kwh_prorytet))+1 FROM tr_kkwhead WHERE fm_idcentrali=NEW.fm_idcentrali  AND th_rodzaj=NEW.th_rodzaj);
   END IF;
   IF (typprorytetu=2) THEN ---grupy i kkw
    NEW.kwh_prorytet=(SELECT NullZero(max(kwh_prorytet))+1 FROM tr_kkwhead WHERE fm_idcentrali=NEW.fm_idcentrali AND thg_idgrupy=NEW.thg_idgrupy  AND th_rodzaj=NEW.th_rodzaj);
   END IF;
   IF (typprorytetu=3 OR typprorytetu=4) THEN ---grupy, kkw i zlecenie
    NEW.kwh_prorytet=(SELECT NullZero(max(kwh_prorytet))+1 FROM tr_kkwhead WHERE fm_idcentrali=NEW.fm_idcentrali AND thg_idgrupy=NEW.thg_idgrupy AND NullZero(zl_idzlecenia)=NullZero(NEW.zl_idzlecenia)  AND th_rodzaj=NEW.th_rodzaj);
   END IF;
  END IF; ---koniec czesci odnosnie prorytetu
 END IF;

 IF (deltaplold<>0 OR deltawykold<>0 OR deltawykcold<>0) THEN
  UPDATE tg_planzlecenia SET pz_iloscroz=pz_iloscroz+deltaplold,pz_ilosczreal=pz_ilosczreal+deltawykold,pz_ilosczrealclosed=pz_ilosczrealclosed+deltawykcold WHERE pz_idplanu=OLD.pz_idplanu;
 END IF;

 IF (deltaplnew<>0 OR deltawyknew<>0 OR deltawykcnew<>0) THEN
  UPDATE tg_planzlecenia SET pz_iloscroz=pz_iloscroz+deltaplnew,pz_ilosczreal=pz_ilosczreal+deltawyknew,pz_ilosczrealclosed=pz_ilosczrealclosed+deltawykcnew WHERE pz_idplanu=NEW.pz_idplanu;
 END IF;
 
 IF (TG_OP='UPDATE') THEN ---czesc odnosnie dat z planowania KKW
  IF (NEW.kwh_flaga&64=0 AND OLD.kwh_flaga&64=64) THEN ---nie jest rozplanowany w calosci usuwamy te daty
   NEW.kwh_dataplanstart=NULL;
   NEW.kwh_dataplanstop=NULL;
  END IF;
  IF (NEW.kwh_flaga&64=64 AND OLD.kwh_flaga&64=0) THEN ---pobieramy daty wynikajace z planow, kkw calkowicie rozplanowane
   NEW.kwh_dataplanstart=(SELECT min(knp_datarozpoczecia) FROM tr_kkwnodplan WHERE tr_kkwnodplan.kwh_idheadu=NEW.kwh_idheadu) ;
   NEW.kwh_dataplanstop=(SELECT max(knp_datazakonczenia) FROM tr_kkwnodplan WHERE tr_kkwnodplan.kwh_idheadu=NEW.kwh_idheadu);
  END IF;
 END IF; ---koniec  odnosnie data z planowania KKW

 IF (TG_OP='UPDATE') THEN ---czesc odnosnie dat rozpoczecia i zakonczenia wykonania oraz zamkniecia KKW
  ----rozpoczecie wykonania
  IF (NEW.kwh_flaga&16=0 AND OLD.kwh_flaga&16=16) THEN ---usunieto wykonania, kasujemy date rozpoczecia wykoniania
   NEW.kwh_datarozwykonania=NULL;
  END IF;
  IF (NEW.kwh_flaga&16=16 AND OLD.kwh_flaga&16=0) THEN ---jest wykonanie pobieramy date rozpoczecia wykonania
   NEW.kwh_datarozwykonania=now();
  END IF;
  ----zakonczenie wykonania
  IF (NEW.kwh_flaga&32=0 AND OLD.kwh_flaga&32=32) THEN ---usunieto jakie. wykonanie, kasujemy date zakonczenia wykoniania
   NEW.kwh_datazakonczeniawyk=NULL;
  END IF;
  IF (NEW.kwh_flaga&32=32 AND OLD.kwh_flaga&32=0) THEN ---jest wykonanie calosci pobieramy date  wykonania
   NEW.kwh_datazakonczeniawyk=now();
  END IF;
  ----zamkniecia KKW
  IF (NEW.kwh_flaga&1=0 AND OLD.kwh_flaga&1=1) THEN ---otwarto KKW
   NEW.kwh_datazamknieciakkw=NULL; ---nulujemy date zakonczenia wykonania jesli wykonanie nie jest w calosci
   IF (NEW.kwh_flaga&32=0) THEN
    NEW.kwh_datazakonczeniawyk=NULL;
   END IF;
  END IF;
  IF (NEW.kwh_flaga&1=1 AND OLD.kwh_flaga&1=0) THEN ---zamknieto
   NEW.kwh_datazamknieciakkw=now();
   ---zamykamy wszystkie otwarte wykonania
   UPDATE tr_kkwnodwyk SET knw_flaga=knw_flaga|1, knw_datawyk=now() WHERE knw_flaga&(1+2)=2 AND kwh_idheadu=NEW.kwh_idheadu;
   ---ustawiamy date zakonczenia wykonania na ostatnie wykonanie w ramach KKW jesli nie jest wykonane w calosci wykonane
   IF (NEW.kwh_flaga&32=0) THEN
    NEW.kwh_datazakonczeniawyk=COALESCE((SELECT max(knw_datawyk) FROM tr_kkwnodwyk AS wyk WHERE wyk.kwh_idheadu=NEW.kwh_idheadu),now());
   END IF;
  END IF;

 END IF; ---koniec  odnosnie daty rozpoczecia wykonania
 
 IF (TG_OP='INSERT') THEN ---ustawiamy prorytet
   typprorytetu=(SELECT cf_defvalue::int FROM tc_config WHERE cf_tabela='KKW_PRORYTET_TYP' LIMIT 1 OFFSET 0);
   IF (typprorytetu=0) THEN ---kkw i zlecenie
    NEW.kwh_prorytet=(SELECT NullZero(max(kwh_prorytet))+1 FROM tr_kkwhead WHERE fm_idcentrali=NEW.fm_idcentrali AND NullZero(zl_idzlecenia)=NullZero(NEW.zl_idzlecenia)  AND th_rodzaj=NEW.th_rodzaj);
   END IF;
   IF (typprorytetu=1) THEN ---kkw
    NEW.kwh_prorytet=(SELECT NullZero(max(kwh_prorytet))+1 FROM tr_kkwhead WHERE fm_idcentrali=NEW.fm_idcentrali  AND th_rodzaj=NEW.th_rodzaj);
   END IF;
   IF (typprorytetu=2) THEN ---grupy i kkw
    NEW.kwh_prorytet=(SELECT NullZero(max(kwh_prorytet))+1 FROM tr_kkwhead WHERE fm_idcentrali=NEW.fm_idcentrali AND thg_idgrupy=NEW.thg_idgrupy  AND th_rodzaj=NEW.th_rodzaj);
   END IF;
   IF (typprorytetu=3 OR typprorytetu=4) THEN ---grupy, kkw i zlecenie
    NEW.kwh_prorytet=(SELECT NullZero(max(kwh_prorytet))+1 FROM tr_kkwhead WHERE fm_idcentrali=NEW.fm_idcentrali AND thg_idgrupy=NEW.thg_idgrupy AND NullZero(zl_idzlecenia)=NullZero(NEW.zl_idzlecenia) AND th_rodzaj=NEW.th_rodzaj);
   END IF;
 END IF;

 IF (TG_OP='DELETE') THEN ---czesc odnosnie prorytetow
  IF ((OLD.kwh_flaga&3)=0 ) THEN ---kkw otwarte, pobieramy ustawienia czy renumerowac prorytety innych kkw
   zmiana_prorytetow=(SELECT cf_defvalue FROM tc_config WHERE cf_tabela='KKW_AUT_ZM_PROR');
   IF (zmiana_prorytetow='1') THEN ---zmieniamy automatycznie innym prorytet
    typprorytetu=(SELECT cf_defvalue::int FROM tc_config WHERE cf_tabela='KKW_PRORYTET_TYP' LIMIT 1 OFFSET 0);
    IF (typprorytetu=0) THEN ---kkw i zlecenie
     UPDATE tr_kkwhead SET kwh_prorytet=kwh_prorytet-1 WHERE fm_idcentrali=OLD.fm_idcentrali AND NullZero(zl_idzlecenia)=NullZero(OLD.zl_idzlecenia) AND kwh_prorytet>OLD.kwh_prorytet  AND th_rodzaj=OLD.th_rodzaj;
    END IF;
    IF (typprorytetu=1) THEN ---samo kkw
     UPDATE tr_kkwhead SET kwh_prorytet=kwh_prorytet-1 WHERE  fm_idcentrali=OLD.fm_idcentrali AND kwh_prorytet>OLD.kwh_prorytet  AND th_rodzaj=OLD.th_rodzaj;
    END IF;
    IF (typprorytetu=2) THEN ---grupa tech i kkw
     UPDATE tr_kkwhead SET kwh_prorytet=kwh_prorytet-1 WHERE fm_idcentrali=OLD.fm_idcentrali AND thg_idgrupy=OLD.thg_idgrupy AND kwh_prorytet>OLD.kwh_prorytet  AND th_rodzaj=OLD.th_rodzaj;
    END IF;
    IF (typprorytetu=3 OR typprorytetu=4) THEN ---zlecenie, grupa i kkw
     UPDATE tr_kkwhead SET kwh_prorytet=kwh_prorytet-1 WHERE fm_idcentrali=OLD.fm_idcentrali AND thg_idgrupy=OLD.thg_idgrupy AND NullZero(zl_idzlecenia)=NullZero(OLD.zl_idzlecenia) AND kwh_prorytet>OLD.kwh_prorytet  AND th_rodzaj=OLD.th_rodzaj;
    END IF;
   END IF;
  END IF; ---koniec prorytetow
  
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
