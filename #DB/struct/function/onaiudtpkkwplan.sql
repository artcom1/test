CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltaold_mag  NUMERIC:=0;
 deltanew_mag  NUMERIC:=0;
BEGIN

 IF (TG_OP<>'INSERT') THEN
  deltaold_mag=deltaold_mag-OLD.kwp_iloscwmag;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (nullZero(OLD.pz_idplanu)=nullZero(NEW.pz_idplanu)) THEN
   deltanew_mag=deltanew_mag+deltaold_mag;
   deltaold_mag=0;
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  deltanew_mag=deltanew_mag+NEW.kwp_iloscwmag;
 END IF;

 IF (deltaold_mag<>0) THEN
  UPDATE tg_planzlecenia SET pz_ilosczreal=getIloscWMag(OLD.pz_idplanu) WHERE pz_idplanu=OLD.pz_idplanu;
 END IF;

 IF (deltanew_mag<>0) THEN
  UPDATE tg_planzlecenia SET pz_ilosczreal=getIloscWMag(NEW.pz_idplanu) WHERE pz_idplanu=NEW.pz_idplanu;
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
