CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE 
    pids INT[];
BEGIN
    IF pracownicy IS NULL OR array_length(pracownicy, 1) = 0 THEN
        RETURN 0;
    ELSE
        SELECT ARRAY(SELECT DISTINCT UNNEST(pracownicy)) INTO pids;    
    END IF;    
        
    INSERT INTO tb_chat_members(chm_chc_id, chm_p_idpracownika)
    SELECT conversationId, p.id
    FROM unnest(pids) AS p(id)
    WHERE NOT EXISTS (
        SELECT * 
        FROM tb_chat_members AS im 
        WHERE im.chm_chc_id=conversationId AND im.chm_p_idpracownika=p.id
        LIMIT 1);
        
    PERFORM pg_notify('chat', conversationId::TEXT);    
    RETURN 1;
END;
$$;
