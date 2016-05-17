CREATE FUNCTION flag_off(flag integer[], index integer) RETURNS integer[]
    LANGUAGE plpgsql
    AS $$
BEGIN 
	return flag_set(flag, index, false);
END;
$$;
