CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 r RECORD;
BEGIN
 
 IF (NEW.prt_idparent_rozm IS NOT NULL) OR (NEW.prt_wplyw<=0) THEN
  RETURN NEW;
 END IF;

 NEW.prt_idparent_rozm=gmr.findPartiaParentRozm(NEW,TRUE);
 IF (NEW.prt_idparent_rozm IS NOT NULL) THEN
  NEW.prt_flaga=NEW.prt_flaga|(1<<11);
 END IF;
 
 RETURN NEW;
END;
$$;
