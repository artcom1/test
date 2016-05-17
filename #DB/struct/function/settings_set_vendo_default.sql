CREATE FUNCTION settings_set_vendo_default(_name text, _value text, _flag integer) RETURNS TABLE(storeid integer, settingid integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM settings_set(NULL, NULL, 0, NULL, _name, _value, NULL, _flag);
END;
$$;


--
--

CREATE FUNCTION settings_set_vendo_default(_context text, _name text, _value text, _flag integer) RETURNS TABLE(storeid integer, settingid integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM settings_set(NULL, _context, 0, NULL, _name, _value, NULL, _flag);
END;
$$;
