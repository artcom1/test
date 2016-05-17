CREATE FUNCTION getroznicalat(date, date) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
	data ALIAS FOR $1;
	datas ALIAS FOR $2;
	drok INT;
BEGIN
	drok := date_part('year', data)::int - date_part('year', datas)::int;
	RETURN drok;
END;
$_$;
