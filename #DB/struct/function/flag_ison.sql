CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN 
 RETURN CASE WHEN flag[index/32] IS NULL
             THEN FALSE
             ELSE (flag[index/32]&(1<<(index%32))) <> 0
	    END;
END;
$$;
