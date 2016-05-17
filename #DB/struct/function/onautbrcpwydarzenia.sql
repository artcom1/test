CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF ((OLD.p_idpracownika<>NEW.p_idpracownika) OR (OLD.rcp_czaswydarzenia::date<>NEW.rcp_czaswydarzenia::date)) THEN
 	PERFORM ZagregujWydarzeniaRCP(OLD.p_idpracownika, OLD.rcp_czaswydarzenia::date, NULL::boolean);
 END IF;

 PERFORM ZagregujWydarzeniaRCP(NEW.p_idpracownika, NEW.rcp_czaswydarzenia::date, NULL::boolean);
 
 RETURN NEW;
END;
$$;
