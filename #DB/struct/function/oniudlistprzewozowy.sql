CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='INSERT') THEN
  UPDATE tg_transport SET lt_flaga=lt_flaga|2 WHERE lt_idtransportu=NEW.lt_idtransportu;
 END IF;


 IF (TG_OP='DELETE') THEN
  UPDATE tg_transport SET lt_flaga=lt_flaga&(~2) WHERE lt_idtransportu=OLD.lt_idtransportu;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END
$$;
