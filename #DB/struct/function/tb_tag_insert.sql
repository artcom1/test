CREATE FUNCTION tb_tag_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    most_right INTEGER;
BEGIN        
    IF NOT EXISTS (SELECT tag_id FROM tb_tag) THEN
        most_right := 1;
    ELSE 
        IF NEW.tag_parent IS NULL THEN
            most_right := (SELECT max(tag_right) FROM tb_tag) + 1;        
        ELSE
            most_right := (SELECT tag_right FROM tb_tag WHERE tag_id = NEW.tag_parent);
        
            UPDATE tb_tag 
            SET tag_left = CASE WHEN tag_left > most_right THEN tag_left + 2 ELSE tag_left END,
                tag_right = tag_right + 2
            WHERE tag_right >= most_right;
        END IF;
    END IF;
    
    NEW.tag_left = most_right;
    NEW.tag_right = most_right+1;
    RETURN NEW;
END;
$$;
