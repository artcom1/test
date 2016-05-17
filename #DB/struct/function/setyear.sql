CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
	data ALIAS FOR $1;
	rok ALIAS FOR $2;
	drok INT;
	ret TIMESTAMP WITH TIME ZONE;
BEGIN
	drok := date_part('year', data)::int;
	drok := rok - drok;
	ret := data + drok * '+1 year'::interval;
	RETURN ret;
END;
$_$;
