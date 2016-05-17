CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltaold_p NUMERIC:=0;
 deltanew_p NUMERIC:=0;
 ischmozl   BOOL:=true;
 ischetap   BOOL:=true;
 tmp        INT:=0;
BEGIN

 ------Kontrola ilosci
 IF (TG_OP<>'INSERT') THEN
  IF ((OLD.kwl_flaga&1)=0) THEN
   deltaold_p=deltaold_p-OLD.kwl_ilosc;
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN

  IF (nullZero(OLD.kwp_idplanu)=nullZero(NEW.kwp_idplanu)) THEN
   deltanew_p=deltanew_p+deltaold_p;
   deltaold_p=0;
  END IF;

  IF (nullZero(OLD.ms_idmozliwosci)=nullZero(NEW.ms_idmozliwosci)) THEN
   ischmozl=false;
  END IF;
  IF (nullZero(OLD.ep_idetapu)=nullZero(NEW.ep_idetapu)) THEN
   ischetap=false;
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN

  IF ((NEW.kwl_flaga&1)=0) THEN
    deltanew_p=deltanew_p+NEW.kwl_ilosc;
  END IF;

  IF (NEW.ms_idmozliwosci IS NOT NULL) AND (ischmozl) THEN
   NEW.ob_idobiektu=(SELECT ob_idobiektu FROM tp_mozliwestanowiska WHERE ms_idmozliwosci=NEW.ms_idmozliwosci);
  END IF;

  IF (NEW.ep_idetapu IS NOT NULL) AND (ischetap) THEN
   NEW.ek_idetapu=(SELECT ek_idetapu FROM tp_etappolproduktu WHERE ep_idetapu=NEW.ep_idetapu);
  END IF;

 END IF;

 IF (TG_OP='INSERT') THEN
  IF (NEW.kwl_lp IS NULL) THEN
   NEW.kwl_lp=getLPPlanOnKKW(NEW.kwp_idplanu,NEW.ep_idetapu);
   UPDATE tp_planonkkw SET kwl_lp=kwl_lp+1 WHERE kwl_lp>=NEW.kwl_lp AND kwp_idplanu=NEW.kwp_idplanu AND kwl_idplanu<>NEW.kwl_idplanu;
   --Oznaczenie rozplanowania - tylko na ostatnim etapie produkcji
  END IF;
 END IF;

 ---Update
 IF (deltaold_p<>0)  THEN
  UPDATE tp_kkwplan SET kwp_iloscrozp=kwp_iloscrozp+deltaold_p WHERE kwp_idplanu=OLD.kwp_idplanu;
 END IF;

 IF (deltanew_p<>0)  THEN
  UPDATE tp_kkwplan SET kwp_iloscrozp=kwp_iloscrozp+deltanew_p WHERE kwp_idplanu=NEW.kwp_idplanu;
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
