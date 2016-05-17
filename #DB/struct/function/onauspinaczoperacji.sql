CREATE FUNCTION onauspinaczoperacji() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
BEGIN
  
 IF (COALESCE(NEW.kwe_idelemudef,0)<>COALESCE(OLD.kwe_idelemudef,0)) THEN
  IF (COALESCE(OLD.kwe_idelemudef,0)>0) THEN -- Na starym domyslnym zeruje flage
   UPDATE tr_kkwnod SET kwe_flaga=kwe_flaga&(~(1<<13)) WHERE kwe_idelemu=OLD.kwe_idelemudef;
  END IF;
  IF (COALESCE(NEW.kwe_idelemudef,0)>0) THEN -- Na nowym domyslnym ja ustawiam
   UPDATE tr_kkwnod SET kwe_flaga=kwe_flaga|(1<<13) WHERE kwe_idelemu=NEW.kwe_idelemudef;
  END IF;
 END IF;
 
 RETURN NEW;
END;
$$;
