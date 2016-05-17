CREATE FUNCTION flag_set(flag integer[], index integer, onoff boolean) RETURNS integer[]
    LANGUAGE plpgsql
    AS $$
DECLARE
	result int[];
	idx int;
	mask int;
BEGIN 
	result = flag;
	idx = index/32;
	mask = 1 << (index%32);
	
	IF onoff THEN 	
		IF result[idx] IS NULL THEN 
			result[idx] = mask;
		ELSE 
			result[idx] = result[idx] | mask;
		END IF;
	ELSE
		IF result[idx] IS NOT NULL THEN 
			result[idx] = result[idx] & ~mask;
		END IF;
	END IF;

	return result;
END;
$$;
