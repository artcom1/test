CREATE FUNCTION onbiudpodgrupatowarow() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 pobraniefull bool:=false;
BEGIN
 
 IF (TG_OP='INSERT') THEN
  pobraniefull=true;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NEW.tpg_nazwa!=OLD.tpg_nazwa) THEN
   pobraniefull=true;
  END IF;
  IF (NullZero(NEW.tpg_parent)!=NullZero(OLD.tpg_parent)) THEN
   pobraniefull=true;
  END IF;
 END IF;

 IF (pobraniefull) THEN
  IF (NEW.tpg_parent IS NULL) THEN
   NEW.tpg_sciezka=NEW.tpg_nazwa;
  ELSE 
   NEW.tpg_sciezka=splaszczPodGrupeTowarow(NEW.tpg_parent)||'??'||NEW.tpg_nazwa;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
