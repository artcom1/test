CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 PERFORM SyncRPZAM(NEW.tel_idelem,NEW.tel_ilosc*NEW.tel_przelnilosci/1000,NEW.tel_nadmiarzam*NEW.tel_przelnilosci/1000);
  
 RETURN NEW;
END;
$$;
