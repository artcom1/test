CREATE FUNCTION floorroundmax(numeric, numeric) RETURNS numeric
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN min(round($1,2),$2);
END
$_$;


--
--

CREATE FUNCTION floorroundmax(mpq, numeric) RETURNS numeric
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN min(round($1,2),$2);
END
$_$;
