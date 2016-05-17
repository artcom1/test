CREATE FUNCTION oniudkkwnodprevnext() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltapold NUMERIC:=0;
 deltapnew NUMERIC:=0;
 deltac NUMERIC:=0;
BEGIN

 IF (TG_OP='INSERT') THEN
  NEW.kwh_idheadu=(SELECT kwh_idheadu FROM tr_kkwnod WHERE kwe_idelemu=NEW.kwe_idprev);
  NEW.knpn_kweilosc=(SELECT kwe_iloscplanwyk+kwe_iloscplanbrak FROM tr_kkwnod WHERE kwe_idelemu=NEW.kwe_idprev);
  NEW.knpn_kwhilosc=(SELECT kwh_iloscoczek FROM tr_kkwhead WHERE kwh_idheadu=NEW.kwh_idheadu);
  IF (NEW.kwh_idheadu<>(SELECT kwh_idheadu FROM tr_kkwnod WHERE kwe_idelemu=NEW.kwe_idnext)) THEN
   RAISE EXCEPTION 'Elementy nie sa w tym samym KKW';
  END IF;
 END IF;

 IF (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
  IF ((NEW.knpn_flaga&((1<<5)|(1<<16)))<>0) THEN
   NEW.knpn_flaga=NEW.knpn_flaga&(~(1<<16));
   RETURN NEW;
  END IF;
 ELSE
  IF ((OLD.knpn_flaga&((1<<5)|(1<<16)))<>0) THEN
   RETURN OLD;
  END IF;  
 END IF;
 
 IF (TG_OP<>'INSERT') THEN
  deltapold=deltapold-OLD.knpn_fromnext;
  IF ((OLD.knpn_flaga&28)=0) THEN
   deltapold=round(deltapold*OLD.knpn_x_licznik/OLD.knpn_x_mianownik,4);
  ELSE
   IF ((OLD.knpn_flaga&28)=4) THEN  ---od ilosci kkw
    IF ((OLD.knpn_x_mianownik*OLD.knpn_kweilosc)>0) THEN
     deltapold=round((deltapold*OLD.knpn_x_licznik*OLD.knpn_kwhilosc)/(OLD.knpn_x_mianownik*OLD.knpn_kweilosc),4);
    END IF;
   END IF;
  END IF;

  IF (OLD.knpn_fromnext<>0) THEN ---jest jakies wykonanie wiec przenosimy rowniez czesc stala
   deltac=deltac-OLD.knpn_x_wspc;
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  deltapnew=deltapnew+NEW.knpn_fromnext;
  IF ((NEW.knpn_flaga&28)=0) THEN
   deltapnew=round(deltapnew*NEW.knpn_x_licznik/NEW.knpn_x_mianownik,4);
  ELSE
   IF ((NEW.knpn_flaga&28)=4) THEN  ---od ilosci kkw
    IF ((NEW.knpn_x_mianownik*NEW.knpn_kweilosc)>0) THEN
     deltapnew=round((deltapnew*NEW.knpn_x_licznik*NEW.knpn_kwhilosc)/(NEW.knpn_x_mianownik*NEW.knpn_kweilosc),4);
    END IF;
   END IF;
  END IF;

  IF (NEW.knpn_fromnext<>0) THEN ---jest jakies wykonanie wiec przenosimy rowniez czesc stala
   deltac=deltac+NEW.knpn_x_wspc;
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
  deltapnew=deltapnew+deltapold+deltac;
  deltapold=0;
 ELSE 
  IF(TG_OP='INSERT') THEN
   deltapnew=deltapnew+deltac;
  ELSE
   IF(TG_OP='DELETE') THEN
    deltapold=deltapold+deltac;
   END IF;

  END IF;
 END IF;

 IF (deltapold<>0) THEN
  UPDATE tr_kkwnod SET kwe_tonext=kwe_tonext+deltapold WHERE kwe_idelemu=OLD.kwe_idprev;
 END IF;

 IF (deltapnew<>0) THEN
  UPDATE tr_kkwnod SET kwe_tonext=kwe_tonext+deltapnew WHERE kwe_idelemu=NEW.kwe_idprev;
 END IF;
 
 IF (TG_OP='INSERT') THEN -- Dodaje nowego poprzednika. Trzeba zaktualizowac nastepnika
  UPDATE tr_kkwnod SET kwe_iloscpoprzednikow=kwe_iloscpoprzednikow+1 WHERE kwe_idelemu=NEW.kwe_idnext;
 END IF;
 
 IF (TG_OP='DELETE') THEN -- Usuwam jednego poprzednika. Trzeba zaktualizowac nastepnika
  UPDATE tr_kkwnod SET kwe_iloscpoprzednikow=kwe_iloscpoprzednikow-1 WHERE kwe_idelemu=OLD.kwe_idnext;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
