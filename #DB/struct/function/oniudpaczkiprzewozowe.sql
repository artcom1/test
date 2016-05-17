CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 _lt_idtransportu INT;
BEGIN

 ----------------------------------------------------------------------------
 --- Aktualizacja znacznika typu paczki na transporcie
 ----------------------------------------------------------------------------
  
 IF (TG_OP='DELETE') THEN
	_lt_idtransportu=OLD.lt_idtransportu;
 ELSE
	_lt_idtransportu=NEW.lt_idtransportu;
 END IF;
 
 PERFORM utransportmaxpaczka(_lt_idtransportu);
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
 
END;
$$;
