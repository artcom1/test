CREATE FUNCTION flag_frombits(flag text) RETURNS integer[]
    LANGUAGE plpgsql
    AS $$
DECLARE
	result int[];
BEGIN 
	result = '[0:0]={0}'::int[];
	
	IF flag IS NULL OR length(flag)=0 THEN
		RETURN result;
	END IF;
	
	FOR i IN 1..length(flag) LOOP		
		IF substr(flag, i, 1)='1' THEN
			result = flag_on(result, i-1);
		END IF;
	END LOOP;
	
	RETURN result;
END;
$$;
