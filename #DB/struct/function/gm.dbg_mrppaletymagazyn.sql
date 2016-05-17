CREATE FUNCTION dbg_mrppaletymagazyn() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='INSERT') THEN
  PERFORM vendo.toLog('DBG: Ustawienie magazynu na: '||COALESCE(NEW.tmg_idmagazynu::text,'<NULL>')||', miejsca: '||COALESCE(NEW.mm_idmiejsca::text,'<NULL>'),261,NEW.mrpp_idpalety);
 END IF;
 
 IF (TG_OP='UPDATE') THEN
  IF (NEW.tmg_idmagazynu IS DISTINCT FROM OLD.tmg_idmagazynu) THEN
   PERFORM vendo.toLog('DBG: Zmiana magazynu na: '||COALESCE(NEW.tmg_idmagazynu::text,'<NULL>')||' z: '||COALESCE(OLD.tmg_idmagazynu::text,'<NULL>'),261,NEW.mrpp_idpalety);
  END IF;
  IF (NEW.mm_idmiejsca IS DISTINCT FROM OLD.mm_idmiejsca) THEN
   PERFORM vendo.toLog('DBG: Zmiana miejsca na: '||COALESCE(NEW.mm_idmiejsca::text,'<NULL>')||' z: '||COALESCE(OLD.mm_idmiejsca::text,'<NULL>'),261,NEW.mrpp_idpalety);
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END;
$$;
