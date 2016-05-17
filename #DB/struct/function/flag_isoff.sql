CREATE FUNCTION flag_isoff(flag integer[], index integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN 
	RETURN NOT flag_ison(flag, index);
END;
$$;
