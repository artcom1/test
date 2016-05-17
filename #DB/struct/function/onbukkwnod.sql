CREATE FUNCTION onbukkwnod() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
BEGIN
 
 IF (NEW.kwe_iloscpoprzednikow<>OLD.kwe_iloscpoprzednikow) THEN
  IF (NEW.kwe_iloscpoprzednikow=0) THEN -- Biore date z kkw
   NEW.kwe_datazakonczenia_prev=(SELECT kwh_datarozp FROM tr_kkwhead WHERE kwh_idheadu=NEW.kwh_idheadu);
  ELSE -- Biore date z poprzednikow
   NEW.kwe_datazakonczenia_prev=(SELECT max(nod.kwe_datazakonczenia) FROM tr_kkwnodprevnext AS pn JOIN tr_kkwnod AS nod ON (nod.kwe_idelemu=pn.kwe_idprev) WHERE kwe_idnext=NEW.kwe_idelemu);  
  END IF;
 END IF;
 
 -- SPINACZE
 IF (NEW.spo_idspinacza<>OLD.spo_idspinacza) THEN -- Tutaj tylko zeruje flage ustawianiem flagi zajmuje sie na triggerze spinacza
  NEW.kwe_flaga=NEW.kwe_flaga&(~(1<<13));
 END IF;
 -- SPINACZE

 RETURN NEW;
END;
$$;
