CREATE FUNCTION flag_on(flag integer[], index integer) RETURNS integer[]
    LANGUAGE plpgsql
    AS $$
BEGIN 
	return flag_set(flag, index, true);
END;
$$;
