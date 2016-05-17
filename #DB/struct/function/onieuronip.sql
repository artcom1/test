CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
 IF (NEW.eun_flaga&1=1) THEN
  IF (COALESCE(NEW.k_idklienta,0)>0) THEN
   UPDATE tb_euronipy SET eun_flaga=eun_flaga&(~(1)) WHERE eun_flaga&1=1 AND k_idklienta=NEW.k_idklienta AND eun_ideuronipu<>NEW.eun_ideuronipu;
  ELSE
   UPDATE tb_euronipy SET eun_flaga=eun_flaga&(~(1)) WHERE eun_flaga&1=1 AND k_idklienta=COALESCE(NEW.k_idklienta,0) AND eun_nip=NEW.eun_nip AND eun_ideuronipu<>NEW.eun_ideuronipu;
  END IF;
 END IF;

 RETURN NEW;
END;
$$;
