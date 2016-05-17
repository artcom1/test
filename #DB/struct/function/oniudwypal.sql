CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltaold NUMERIC:=0;
 deltanew NUMERIC:=0;
 deltaoldb NUMERIC:=0;
 deltanewb NUMERIC:=0;
BEGIN

 IF (TG_OP<>'INSERT') THEN
  IF (((OLD.wp_flaga&1)=0) OR ((OLD.wp_flaga&2)=2)) THEN
   deltaold=deltaold-(OLD.wp_ilosc-OLD.wp_pustych);
   deltaoldb=deltaoldb-OLD.wp_brakow;
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  IF (((NEW.wp_flaga&1)=0) OR ((NEW.wp_flaga&2)=2)) THEN
   deltanew=deltanew+(NEW.wp_ilosc-NEW.wp_pustych);
   deltanewb=deltanewb+NEW.wp_brakow;
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (nullZero(OLD.kwe_idelemu)=nullZero(NEW.kwe_idelemu)) THEN
   deltanew=deltanew+deltaold;
   deltanewb=deltanewb+deltaoldb;
   deltaold=0;
   deltaoldb=0;
  END IF;
 END IF;
 

 IF ((deltaold<>0) OR (deltaoldb<>0)) THEN
  UPDATE tp_kkwelem SET kwe_stanst=kwe_stanst+deltaold,kwe_brakow=kwe_brakow+deltaoldb WHERE kwe_idelemu=OLD.kwe_idelemu;
 END IF;

 IF ((deltanew<>0) OR (deltanewb<>0)) THEN
  UPDATE tp_kkwelem SET kwe_stanst=kwe_stanst+deltanew,kwe_brakow=kwe_brakow+deltanewb WHERE kwe_idelemu=NEW.kwe_idelemu;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
