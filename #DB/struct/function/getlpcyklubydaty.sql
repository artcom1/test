CREATE FUNCTION getlpcyklubydaty(timestamp with time zone, timestamp with time zone, interval) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
	datarozp ALIAS FOR $1;
	datacyklu ALIAS FOR $2;
	okres ALIAS FOR $3;

	data DATE;
	ret INT;
BEGIN
	ret := 0;

	data := datarozp + ret * okres;
	WHILE (data < datacyklu) LOOP
		ret := ret + 1;
		data := datarozp + ret * okres;
	END LOOP;

	RETURN ret;
END;
$_$;
