CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 pobraniefull bool:=false;
BEGIN
 
 IF (TG_OP='INSERT') THEN
  pobraniefull=true;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NEW.tgr_nazwa!=OLD.tgr_nazwa) THEN
   pobraniefull=true;
  END IF;
  IF (NullZero(NEW.tgr_parent)!=NullZero(OLD.tgr_parent)) THEN
   pobraniefull=true;
  END IF;
 END IF;

 IF (pobraniefull) THEN
  IF (NEW.tgr_parent IS NULL) THEN
   NEW.tgr_sciezka=NEW.tgr_nazwa;
  ELSE 
   NEW.tgr_sciezka=splaszczGrupeTowarow(NEW.tgr_parent)||'??'||NEW.tgr_nazwa;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
