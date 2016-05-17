CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM settings_set(NULL, NULL, 0, NULL, _name, _value, NULL, _flag);
END;
$$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM settings_set(NULL, _context, 0, NULL, _name, _value, NULL, _flag);
END;
$$;
