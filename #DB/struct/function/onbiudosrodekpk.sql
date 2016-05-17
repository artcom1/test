CREATE FUNCTION onbiudosrodekpk() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 pobraniefull bool:=false;
BEGIN
 
 IF (TG_OP='INSERT') THEN
  pobraniefull=true;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NEW.opk_nazwa!=OLD.opk_nazwa) THEN
   pobraniefull=true;
  END IF;
  IF (NullZero(NEW.opk_parent)!=NullZero(OLD.opk_parent)) THEN
   pobraniefull=true;
  END IF;
 END IF;

 IF (pobraniefull) THEN
  IF (NEW.opk_parent IS NULL) THEN
   NEW.opk_sciezka=NEW.opk_nazwa;
  ELSE 
   NEW.opk_sciezka=splaszczOsrodekPK(NEW.opk_parent)||'??'||NEW.opk_nazwa;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
