CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
   
 IF ((NEW.ttw_flaga&98304)<>(OLD.ttw_flaga&98304)) THEN
  INSERT INTO tm_debuglog
   (dl_txt,dl_vid)
  VALUES
   ('Zmiana chodliwosci',NEW.ttw_idtowaru);
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;

 RETURN NEW;
END;$$;
