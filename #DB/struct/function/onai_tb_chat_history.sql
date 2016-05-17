CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE tb_chat_conversation AS c
	SET chc_chh_id_first = COALESCE(c.chc_chh_id_first, NEW.chh_id),
		chc_chh_id_last = NEW.chh_id
	WHERE c.chc_id = NEW.chh_chc_id;

	UPDATE tb_chat_members AS m
	SET chm_chh_id_lastreaded = NEW.chh_id,
		chm_readdatetime = now()
	WHERE m.chm_chc_id = NEW.chh_chc_id
		AND m.chm_p_idpracownika = NEW.chh_p_idpracownika;
	
	PERFORM pg_notify('chat', NEW.chh_chc_id::TEXT || ',' || NEW.chh_p_idpracownika::TEXT || ',' || NEW.chh_id::TEXT);		
	RETURN NEW;   
END;
$$;
