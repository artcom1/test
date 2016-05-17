CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM pg_notify('chat', NEW.chm_chc_id::TEXT || ',' || NEW.chm_p_idpracownika::TEXT);
	RETURN NEW;   
END;
$$;
