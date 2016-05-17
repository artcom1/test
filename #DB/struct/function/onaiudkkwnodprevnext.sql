CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE 
BEGIN
 
 IF (TG_OP='INSERT') THEN -- Dodaje nowego poprzednika. Trzeba zaktualizowac nastepnika
  UPDATE tr_kkwnod SET kwe_iloscpoprzednikow=kwe_iloscpoprzednikow+1 WHERE kwe_idelemu=NEW.kwe_idnext;
 END IF;
 
 IF (TG_OP='UPDATE') THEN -- Zmieniam poprzednika. Moze trzeba zaktualizowac nastepnika
  IF ((NEW.knpn_flaga&(1<<5))<>(OLD.knpn_flaga&(1<<5))) THEN
   IF ((NEW.knpn_flaga&(1<<5))=(1<<5)) THEN
    UPDATE tr_kkwnod SET kwe_iloscpoprzednikow=kwe_iloscpoprzednikow-1 WHERE kwe_idelemu=NEW.kwe_idnext;
   ELSE
    UPDATE tr_kkwnod SET kwe_iloscpoprzednikow=kwe_iloscpoprzednikow+1 WHERE kwe_idelemu=NEW.kwe_idnext;
   END IF;
  END IF;
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
