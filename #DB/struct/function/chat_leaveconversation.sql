CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF pracownicy IS NULL OR array_length(pracownicy, 1) = 0 THEN
        RETURN 0; 
    END IF;    
        
    DELETE FROM tb_chat_members
    WHERE chm_chc_id = conversationId
        AND EXISTS (SELECT * FROM unnest(pracownicy) AS p(id) WHERE id = chm_p_idpracownika);
        
    PERFORM pg_notify('chat', conversationId::TEXT);    
    RETURN 1;
END;
$$;
