CREATE FUNCTION onaiudkhwymiarysumvalues() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE    
BEGIN
 
 IF (TG_OP='INSERT') THEN
  IF (vendo.getParam('DONTREVZAPISELEM')='') THEN  --- ''    
   UPDATE kh_zapisyelem SET zp_idelzapisu=zp_idelzapisu WHERE zp_idelzapisu=NEW.zp_idelzapisu;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  IF (vendo.getParam('DONTREVZAPISELEM')='') THEN  --- ''    
   UPDATE kh_zapisyelem SET zp_idelzapisu=zp_idelzapisu WHERE zp_idelzapisu=OLD.zp_idelzapisu;
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (
      (sign(NEW.wmm_valuerestwnwal)<>sign(OLD.wmm_valuerestwnwal)) OR
      (sign(NEW.wmm_valuerestmawal)<>sign(OLD.wmm_valuerestmawal)) OR
      (sign(NEW.wmm_valuerestwn)<>sign(OLD.wmm_valuerestwn)) OR
      (sign(NEW.wmm_valuerestma)<>sign(OLD.wmm_valuerestma))
     )
  THEN
   IF (vendo.getParam('DONTREVZAPISELEM')='') THEN  --- ''    
    UPDATE kh_zapisyelem SET zp_idelzapisu=zp_idelzapisu WHERE zp_idelzapisu=OLD.zp_idelzapisu;
   END IF;
  END IF;

  IF (COALESCE(NEW.mc_miesiac,-1)<>COALESCE(OLD.mc_miesiac,-1)) OR (NEW.wmm_isbufor<>OLD.wmm_isbufor) THEN
   UPDATE kh_wymiaryvalues SET mc_miesiac=NEW.mc_miesiac,wmv_isbufor=NEW.wmm_isbufor WHERE wmm_idsumy=NEW.wmm_idsumy;
  END IF;

 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;

 RETURN NEW;
END;
$$;
