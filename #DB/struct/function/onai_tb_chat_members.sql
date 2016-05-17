CREATE FUNCTION onai_tb_chat_members() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM pg_notify('chat', NEW.chm_chc_id::TEXT || ',' || NEW.chm_p_idpracownika::TEXT);
	RETURN NEW;   
END;
$$;
