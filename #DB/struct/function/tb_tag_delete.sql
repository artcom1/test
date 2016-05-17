CREATE FUNCTION tb_tag_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
    --DELETE FROM tb_tag
    --WHERE tb_left >= OLD.tb_left AND tb_right <= OLD.tb_right;
    
    UPDATE tb_tag
    SET tag_left = CASE WHEN tag_left > OLD.tag_right 
				               THEN tag_left - (OLD.tag_right - OLD.tag_left + 1)
																			ELSE tag_left END,
        tag_right = tag_right - (OLD.tag_right - OLD.tag_left + 1)
    WHERE tag_right > OLD.tag_right;
				
				RETURN OLD;
END;
$$;
