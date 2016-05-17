CREATE FUNCTION chat_getorcreateconversation(pracownicy integer[]) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE 
    ci INT;
    pids INT[];
BEGIN
    IF pracownicy IS NULL OR array_length(pracownicy, 1) = 0 THEN
        RETURN NULL;
    ELSE
        SELECT ARRAY(SELECT DISTINCT UNNEST(pracownicy)) INTO pids;    
    END IF;    
    
    ci := (WITH members(id, mbs) AS
        (
            SELECT c.chc_id AS id,
                   ARRAY(SELECT chm_p_idpracownika FROM tb_chat_members AS m WHERE m.chm_chc_id = c.chc_id) AS mbs
            FROM tb_chat_conversation AS c
        )
        SELECT m.id
        FROM members AS m
        WHERE array_length(m.mbs, 1) = array_length(pids, 1)
            AND m.mbs @> pids
        LIMIT 1);
        
    IF ci IS NOT NULL THEN 
        RETURN ci;
    END IF;
    
    INSERT INTO tb_chat_conversation(chc_chh_id_first)
    VALUES (NULL)
    RETURNING chc_id INTO ci;
        
    INSERT INTO tb_chat_members(chm_chc_id, chm_p_idpracownika)
    SELECT ci, *
    FROM unnest(pids);      
    
    RETURN ci;
END;
$$;
