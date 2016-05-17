CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltailosci NUMERIC:=0;
 idzlecenia INT:=0;
BEGIN
  IF (TG_OP = 'INSERT') THEN
    idzlecenia=NEW.zl_idzlecenia;
    deltailosci=NEW.kz_ilosc;
  ELSE
   IF (TG_OP = 'UPDATE') THEN
    idzlecenia=NEW.zl_idzlecenia;
    deltailosci=NEW.kz_ilosc-OLD.kz_ilosc;
   ELSE 
    idzlecenia=OLD.zl_idzlecenia;
    deltailosci=-OLD.kz_ilosc;
   END IF;
  END IF;
  
  ---uaktualnienie tg_zlecenia na polu zl_planprzychod o deltaplan
  UPDATE tg_zlecenia SET zl_liczbaosob=deltailosci+zl_liczbaosob WHERE zl_idzlecenia=idzlecenia;
  
  IF (TG_OP = 'DELETE') THEN
    RETURN OLD;
  ELSE
    RETURN NEW;
  END IF;
END;
$$;
