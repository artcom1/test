CREATE FUNCTION flag_value(flag integer[], ifrom integer, icount integer) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE
	result int8;
BEGIN 
	result = 0;

	IF icount <= 0 THEN
		RETURN 0;
	END IF;

	FOR i IN ifrom..(ifrom+icount-1) LOOP
		IF flag_ison(flag, i) THEN
			result = result + (1::int8 << (i-ifrom));
		END IF;
	END LOOP;

	RETURN result;
END;
$$;
