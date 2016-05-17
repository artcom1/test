CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN 
	return flag_set(flag, index, true);
END;
$$;
