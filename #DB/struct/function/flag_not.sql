CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
	result int[];
BEGIN 
	FOR i IN array_lower(a, 1)..array_upper(a, 1) LOOP
		result[i] = ~nullzero(a[i]);
	END LOOP;

	RETURN result;
END;
$$;
