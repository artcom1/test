CREATE FUNCTION zdarzenie_isticketheader(zdi_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN 
	return zdi_id >= 10000;
END;
$$;
