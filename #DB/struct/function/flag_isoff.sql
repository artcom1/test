CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN 
	RETURN NOT flag_ison(flag, index);
END;
$$;
