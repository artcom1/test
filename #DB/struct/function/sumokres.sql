CREATE FUNCTION sumokres(numeric, date, date, date) RETURNS numeric
    LANGUAGE sql IMMUTABLE
    AS $_$
SELECT (CASE WHEN $2>=$3 AND $2<=$4 THEN $1 ELSE 0 END)
$_$;


--
--

CREATE FUNCTION sumokres(numeric, integer, integer, integer) RETURNS numeric
    LANGUAGE sql IMMUTABLE
    AS $_$
SELECT (CASE WHEN $2>=$3 AND $2<=$4 THEN $1 ELSE 0 END)
$_$;
