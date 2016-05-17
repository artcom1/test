CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
 
 --- Wstawianie id klienta 
 IF (NEW.lk_idczklienta <> 0) THEN
  NEW.k_idklienta=(SELECT k_idklienta FROM tb_ludzieklienta WHERE lk_idczklienta=NEW.lk_idczklienta);
 END IF;

 RETURN NEW;
END;
$$;
