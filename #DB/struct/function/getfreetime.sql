CREATE FUNCTION getfreetime(timestamp without time zone, timestamp without time zone, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN getMinutesFromSpan($2-$1)-getWorkTime($1,$2,$3);
END
$_$;


--
--

CREATE FUNCTION getfreetime(timestamp without time zone, timestamp without time zone, integer, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN getMinutesFromSpan($2-$1)-getWorkTime($1,$2,$3,$4);
END
$_$;
