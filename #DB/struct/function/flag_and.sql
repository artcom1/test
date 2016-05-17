CREATE FUNCTION flag_and(a integer[], b integer[]) RETURNS integer[]
    LANGUAGE plpgsql
    AS $$
DECLARE
	result int[];
	start int;
	stop int;
BEGIN 
	start = min(array_lower(a, 1), array_lower(b, 1));
	stop = max(array_upper(a, 1), array_upper(b, 1));

	FOR i IN start..stop LOOP
		result[i] = nullzero(a[i]) & nullzero(b[i]);
	END LOOP;

	RETURN result;
END;
$$;
