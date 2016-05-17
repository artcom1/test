CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN 
	return zdi_id >= 10000;
END;
$$;
