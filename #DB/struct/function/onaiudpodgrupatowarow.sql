CREATE FUNCTION onaiudpodgrupatowarow() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
 
 IF (TG_OP='UPDATE') THEN
  IF (NEW.tpg_nazwa!=OLD.tpg_nazwa OR NullZero(NEW.tpg_parent)!=NullZero(OLD.tpg_parent)) THEN
   UPDATE tg_podgrupytow SET tpg_sciezka=splaszczPodGrupeTowarow(tpg_idpodgrupy) WHERE tpg_l>NEW.tpg_l AND tpg_r<NEW.tpg_r;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
