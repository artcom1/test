CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 id INT;
BEGIN

 id=(SELECT pki_idtrans FROM tg_packinfo WHERE tr_idtrans=NEW.tr_idtrans);
 IF (id IS NULL) THEN
  INSERT INTO tg_packinfo
   (pki_idtrans,tr_idtrans)
  VALUES
   (NEW.tr_idtrans,NEW.tr_idtrans);
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END; 
$$;
