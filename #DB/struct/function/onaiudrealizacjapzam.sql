CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltaold_abs NUMERIC:=0;
 deltanew_abs NUMERIC:=0;
 deltaold_tominus NUMERIC:=0;
 deltanew_tominus NUMERIC:=0;
 gdzieprzeniesc INT:=0;
BEGIN

 IF (TG_OP<>'INSERT') THEN
  deltaold_abs=deltaold_abs-(OLD.rm_iloscf-min(OLD.rm_iloscf,OLD.rm_iloscfminus))*OLD.rm_przell/OLD.rm_przelm;
  IF (OLD.rm_idtominus IS NOT NULL) THEN
   deltaold_tominus=deltanew_tominus-OLD.rm_iloscf;
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  deltanew_abs=deltanew_abs+(NEW.rm_iloscf-min(NEW.rm_iloscf,NEW.rm_iloscfminus))*NEW.rm_przell/NEW.rm_przelm;
  IF (NEW.rm_idtominus IS NOT NULL) THEN
   deltanew_tominus=deltanew_tominus+NEW.rm_iloscf;
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (nullZero(NEW.tel_idpzam)=nullZero(OLD.tel_idpzam)) THEN
   deltanew_abs=deltanew_abs+deltaold_abs;
   deltaold_abs=0;
  END IF;
  IF (NEW.rm_idtominus IS NOT DISTINCT FROM OLD.rm_idtominus) THEN
   deltanew_tominus=deltanew_tominus+deltaold_tominus;
   deltaold_tominus=0;
  END IF;
 END IF;


 IF (deltaold_abs<>0) THEN
  gdzieprzeniesc=(OLD.rm_flaga>>4)&15;
  IF (gdzieprzeniesc=5) THEN
   PERFORM checkTransElemChange(OLD.tel_idelemsrc);
   PERFORM checkPackElemChange(OLD.pe_idelemuzam);
   UPDATE tg_packelem SET pe_iloscinpz=round(pe_iloscinpz+deltaold_abs,4),pe_iloscf=round(pe_iloscf+deltaold_abs,4) WHERE pe_idelemu=OLD.pe_idelemuzam;
   UPDATE tg_transelem SET tel_ilosc=tel_ilosc+(1000*deltaold_abs/tel_przelnilosci),tel_iloscf=tel_iloscf+deltaold_abs,tel_flaga=tel_flaga|8192 WHERE tel_idelem=OLD.tel_idelemsrc;
   DELETE FROM tg_transelem WHERE (tel_idelem=OLD.tel_idelemsrc) AND (tel_ilosc=0) AND (tel_newflaga&(1<<18))<>0;
   DELETE FROM tg_packelem WHERE (pe_idelemu=OLD.pe_idelemuzam) AND pe_iloscf=0;
  END IF;
 END IF;

 IF (deltanew_abs<>0) THEN
  gdzieprzeniesc=(NEW.rm_flaga>>4)&15;
  IF (gdzieprzeniesc=5) THEN
   PERFORM checkTransElemChange(NEW.tel_idelemsrc);
   PERFORM checkPackElemChange(NEW.pe_idelemuzam);
   UPDATE tg_packelem SET pe_iloscinpz=round(pe_iloscinpz+deltanew_abs,4),pe_iloscf=round(pe_iloscf+deltanew_abs,4) WHERE pe_idelemu=NEW.pe_idelemuzam;
   UPDATE tg_transelem SET tel_ilosc=tel_ilosc+(1000*deltanew_abs/tel_przelnilosci),tel_iloscf=tel_iloscf+deltanew_abs,tel_flaga=tel_flaga|8192 WHERE tel_idelem=NEW.tel_idelemsrc;
  END IF;
 END IF;
  
 IF (deltaold_tominus<>0) THEN
  UPDATE tg_realizacjapzam SET rm_iloscfminus=rm_iloscfminus+deltaold_tominus WHERE rm_idrealizacji=OLD.rm_idtominus;  
 END IF;
 
 IF (deltanew_tominus<>0) THEN
  UPDATE tg_realizacjapzam SET rm_iloscfminus=rm_iloscfminus+deltanew_tominus WHERE rm_idrealizacji=NEW.rm_idtominus;  
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
