CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$  
BEGIN
 
 IF (TG_OP='INSERT' ) THEN
  IF ((NEW.sz_flaga&3)!=0 ) THEN
   PERFORM oznaczMaTowaryPowiazane(NEW.ttw_idtowarusrc,1);  
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
 ---oznaczac dla zmiany 
  IF (NEW.ttw_idtowarusrc!=OLD.ttw_idtowarusrc AND (NEW.sz_flaga&3)!=0) THEN
  ---gdy sie zmienil towar zrodlowy
   PERFORM oznaczMaTowaryPowiazane(OLD.ttw_idtowarusrc,(SELECT count(*)::int from tg_skladnikizestawu WHERE ttw_idtowarusrc=OLD.ttw_idtowarusrc AND sz_idskladnika!=OLD.sz_idskladnika AND (sz_flaga&3)!=0));
   PERFORM oznaczMaTowaryPowiazane(NEW.ttw_idtowarusrc,1);
  END IF;
 END IF;
  
 IF (TG_OP='DELETE') THEN
  IF ((OLD.sz_flaga&3)!=0) THEN
   PERFORM oznaczMaTowaryPowiazane(OLD.ttw_idtowarusrc,(SELECT count(*)::int from tg_skladnikizestawu WHERE ttw_idtowarusrc=OLD.ttw_idtowarusrc AND sz_idskladnika!=OLD.sz_idskladnika AND (sz_flaga&3)!=0));  
  END IF;

  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
