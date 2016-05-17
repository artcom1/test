CREATE FUNCTION onbiudgrupawwwtowarow() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 pobraniefull bool:=false;
BEGIN
 
 IF (TG_OP='INSERT') THEN
  pobraniefull=true;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NEW.tgw_nazwa!=OLD.tgw_nazwa) THEN
   pobraniefull=true;
  END IF;
  IF (NullZero(NEW.tgw_parent)!=NullZero(OLD.tgw_parent)) THEN
   pobraniefull=true;
  END IF;
 END IF;

 IF (pobraniefull) THEN
  IF (NEW.tgw_parent IS NULL) THEN
   NEW.tgw_sciezka=NEW.tgw_nazwa;
  ELSE 
   NEW.tgw_sciezka=splaszczGrupeWWWTowarow(NEW.tgw_parent)||'??'||NEW.tgw_nazwa;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
