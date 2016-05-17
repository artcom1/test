CREATE FUNCTION flag_bits(flag integer[]) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	result TEXT;
BEGIN 
	result = '';

	IF array_length(flag, 1) IS NULL THEN
		return 0::bit(32)::text;
	END IF;
	
	FOR i IN array_lower(flag, 1)..array_upper(flag, 1) LOOP
		IF flag[i] IS NULL THEN
			result = 0::bit(32)::text || result;
		ELSE
			result = flag[i]::bit(32)::text || result;			
		END IF;
	END LOOP;

	RETURN text_reverse(result);
END;
$$;
