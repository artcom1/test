CREATE FUNCTION onbiudrodzajklienta() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 pobraniefull bool:=false;
BEGIN
 
 IF (TG_OP='INSERT') THEN
  pobraniefull=true;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NEW.rk_typrodzaju!=OLD.rk_typrodzaju) THEN
   pobraniefull=true;
  END IF;
  IF (NullZero(NEW.rk_parent)!=NullZero(OLD.rk_parent)) THEN
   pobraniefull=true;
  END IF;
 END IF;

 IF (pobraniefull) THEN
  IF (NEW.rk_parent IS NULL) THEN
   NEW.rk_sciezka=NEW.rk_typrodzaju;
  ELSE 
   NEW.rk_sciezka=splaszczRodzajKlienta(NEW.rk_parent)||'??'||NEW.rk_typrodzaju;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
