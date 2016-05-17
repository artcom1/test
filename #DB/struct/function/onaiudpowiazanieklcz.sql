CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 idklienta INT;
BEGIN

 IF (TG_OP='DELETE') THEN
  UPDATE tb_klient SET lk_czdomyslny=0 WHERE lk_czdomyslny=OLD.lk_idczklienta AND k_idklienta=OLD.k_idklienta;
  UPDATE tb_ludzieklienta SET lk_ileklientow=lk_ileklientow-1, k_idklienta=zerowanieDomyslnegoKlienta(k_idklienta,OLD.k_idklienta) WHERE lk_idczklienta=OLD.lk_idczklienta;
  return OLD;
 END IF;

 IF (TG_OP='INSERT') THEN
  UPDATE tb_ludzieklienta SET lk_ileklientow=lk_ileklientow+1 WHERE lk_idczklienta=NEW.lk_idczklienta;
  idklienta=(SELECT k_idklienta FROM tb_ludzieklienta WHERE lk_idczklienta=NEW.lk_idczklienta);
  
  IF (idklienta=0 OR idklienta=NULL) THEN
      UPDATE tb_ludzieklienta SET k_idklienta=NEW.k_idklienta WHERE lk_idczklienta=NEW.lk_idczklienta;
  END IF;
  
 END IF;
  
 RETURN NEW;

END;
$$;
