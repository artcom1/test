CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 iter INT;
BEGIN

  IF (TG_OP = 'INSERT') THEN
    iter=(SELECT 1+NullZero(max(ps_lp)) FROM tg_paczkaspedycyjna WHERE lt_idtransportu=NEW.lt_idtransportu);
    NEW.ps_lp=iter;
  END IF;

  IF (TG_OP = 'DELETE') THEN
    UPDATE tg_paczkaspedycyjna SET ps_lp=ps_lp-1 WHERE lt_idtransportu=OLD.lt_idtransportu AND ps_lp>OLD.ps_lp;
    RETURN OLD;
  END IF;
 
  RETURN NEW;
END;
$$;
