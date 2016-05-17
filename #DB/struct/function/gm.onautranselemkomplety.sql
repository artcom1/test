CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
 IF (NEW.tel_newflaga&256=256) AND (((NEW.tel_new2flaga>>17)&15) IN (0,1,2)) THEN
 ---tylko dla rekordow ktore sa kompletami - dodatkowy bezpiecznik
  UPDATE tg_transelem SET tel_ilosc=NEW.tel_ilosc WHERE tel_skojzestaw=NEW.tel_idelem AND (tel_newflaga&(1<<29))=0 AND tel_ilosc<>NEW.tel_ilosc AND (((NEW.tel_new2flaga>>17)&15) IN (0,1,2));
 END IF;

 RETURN NEW;
END;
$$;
