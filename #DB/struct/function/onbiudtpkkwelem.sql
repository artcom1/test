CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltaoldh  NUMERIC:=0;
 deltanewh  NUMERIC:=0;
 deltaoldhb NUMERIC:=0;
 deltanewhb NUMERIC:=0;
 deltaoldp  NUMERIC:=0;
 deltanewp  NUMERIC:=0;
 flaga      INT;
BEGIN

 IF (TG_OP='INSERT') THEN
  NEW.pp_idpolproduktu=(SELECT pp_idpolproduktu FROM tp_kkwhead WHERE kwh_idheadu=NEW.kwh_idheadu);
  NEW.ek_idetapu=(SELECT ek_idetapu FROM tp_etappolproduktu WHERE ep_idetapu=NEW.ep_idetapu);
  flaga=(SELECT ep_flaga FROM tp_etappolproduktu WHERE pp_idpolproduktu=NEW.pp_idpolproduktu AND ek_idetapu=NEW.ek_idetapu LIMIT 1 OFFSET 0);
  IF (flaga IS NOT NULL) THEN 
   NEW.kwe_flaga=NEW.kwe_flaga|((flaga&1)<<2); --- Przenoszenie do magazynu
  END IF;
  RAISE NOTICE 'MAM ID %',NEW.pp_idpolproduktu;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (nullZero(NEW.kwe_prevelem)<>nullZero(OLD.kwe_prevelem)) THEN
   RAISE EXCEPTION 'Nie mozna zmieniac poprzedniego etapu!!!';
  END IF;
  IF (nullZero(NEW.kwh_idheadu)<>nullZero(OLD.kwh_idheadu)) THEN
   RAISE EXCEPTION 'Nie mozna zmieniac naglowka KKW!!!';
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  IF (NEW.kwe_prevelem IS NOT NULL) THEN
   PERFORM upewnijPrzekazanie(NULL,NEW.kwe_prevelem,NULL,NEW.kwe_idelemu,NEW.kwe_stanst,1);
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  NEW.kwe_pozostalo=NEW.kwe_stanst+NEW.kwe_fromother-NEW.kwe_brakow;
  IF (NEW.kwe_pozostalo<0) THEN
   RAISE EXCEPTION 'Ilosc brakow nie moze przekroczyc liczby przeznaczonej do obrobki!',NEW.kwe_idelemu;
  END IF;
  NEW.kwe_pozostalo=NEW.kwe_pozostalo+NEW.kwe_added-NEW.kwe_tonext;
  IF (NEW.kwe_pozostalo<0) THEN
   RAISE EXCEPTION 'Ilosc pozostala na etapie % nie moze byc mniejsza od 0!',NEW.kwe_idelemu;
  END IF;
 END IF;

 IF (TG_OP<>'INSERT') THEN
  deltaoldh=deltaoldh-OLD.kwe_pozostalo;
  deltaoldhb=deltaoldhb-OLD.kwe_brakow;
  IF (OLD.kwe_flaga&32<>0) THEN
   deltaoldp=deltaoldp-(OLD.kwe_stanst+OLD.kwe_fromother-OLD.kwe_brakow);
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  deltanewh=deltanewh+NEW.kwe_pozostalo;
  deltanewhb=deltanewhb+NEW.kwe_brakow;
  IF (NEW.kwe_flaga&32<>0) THEN
   deltanewp=deltanewp+(NEW.kwe_stanst+NEW.kwe_fromother-NEW.kwe_brakow);
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (nullZero(OLD.kwh_idheadu)=nullZero(NEW.kwh_idheadu)) THEN
   deltanewh=deltanewh+deltaoldh;
   deltanewhb=deltanewhb+deltaoldhb;
   deltanewp=deltanewp+deltaoldp;
   deltaoldh=0;
   deltaoldhb=0;
   deltaoldp=0;
  END IF;
 END IF;


 IF (deltaoldh<>0) OR (deltaoldhb<>0) OR (deltaoldp<>0)  THEN
  UPDATE tp_kkwhead SET kwh_stan=kwh_stan+deltaoldh,kwh_brakow=kwh_brakow+deltaoldhb,kwh_ilosczr=kwh_ilosczr+deltaoldp WHERE kwh_idheadu=OLD.kwh_idheadu;
  deltaoldh=0;
  deltaoldhb=0;
 END IF;

 IF (deltanewh<>0) OR (deltanewhb<>0) OR (deltanewp<>0)  THEN
  UPDATE tp_kkwhead SET kwh_stan=kwh_stan+deltanewh,kwh_brakow=kwh_brakow+deltanewhb,kwh_ilosczr=kwh_ilosczr+deltanewp WHERE kwh_idheadu=NEW.kwh_idheadu;
  deltanewh=0;
  deltanewhb=0;
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
