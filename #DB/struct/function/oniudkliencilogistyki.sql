CREATE FUNCTION oniudkliencilogistyki() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 
BEGIN

 IF (TG_OP = 'INSERT') THEN
  NEW.kl_lp=(SELECT 1+NullZero(max(kl_lp)) FROM tg_kliencilogistyki WHERE lt_idtransportu=NEW.lt_idtransportu);  
 END IF;


 IF (TG_OP = 'DELETE') THEN
  UPDATE tg_kliencilogistyki SET kl_lp=kl_lp-1 WHERE lt_idtransportu=OLD.lt_idtransportu AND kl_lp>OLD.kl_lp;

  RETURN OLD;
 END IF;

 RETURN NEW;
END;
$$;
