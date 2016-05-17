CREATE FUNCTION onbiudtpkkwplan() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltaold_rozp NUMERIC:=0;
 deltanew_rozp NUMERIC:=0;
BEGIN

 IF (TG_OP<>'INSERT') THEN
  deltaold_rozp=deltaold_rozp-OLD.kwp_iloscplan;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (nullZero(OLD.pz_idplanu)=nullZero(NEW.pz_idplanu)) THEN
   deltanew_rozp=deltanew_rozp+deltaold_rozp;
   deltaold_rozp=0;
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  deltanew_rozp=deltanew_rozp+NEW.kwp_iloscplan;
 END IF;

 IF (deltaold_rozp<>0) THEN
  UPDATE tg_planzlecenia SET pz_iloscroz=pz_iloscroz+deltaold_rozp WHERE pz_idplanu=OLD.pz_idplanu;
 END IF;

 IF (deltanew_rozp<>0) THEN
  UPDATE tg_planzlecenia SET pz_iloscroz=pz_iloscroz+deltanew_rozp WHERE pz_idplanu=NEW.pz_idplanu;
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
