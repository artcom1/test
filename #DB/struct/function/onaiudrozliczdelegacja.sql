CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
	IF (TG_OP='DELETE' OR TG_OP='UPDATE') THEN
  
		IF (OLD.lt_idtransportu>0 AND (OLD.rd_flaga&1)=1) THEN

			UPDATE tg_transport SET lt_rozliczenia=lt_rozliczenia-round(OLD.rd_kwota*OLD.rd_kurswaluty,2) WHERE lt_idtransportu=OLD.lt_idtransportu;

		END IF; 
 
	END IF;



	
	IF (TG_OP='INSERT' OR TG_OP='UPDATE') THEN

		IF (NEW.lt_idtransportu>0 AND (NEW.rd_flaga&1)=1) THEN

			UPDATE tg_transport SET lt_rozliczenia=lt_rozliczenia+round(NEW.rd_kwota*NEW.rd_kurswaluty,2) WHERE lt_idtransportu=NEW.lt_idtransportu;

		
END IF;

	END IF;

	IF (TG_OP='DELETE') THEN
		RETURN OLD;
	ELSE
		RETURN NEW;
	END IF;
END;
$$;
