CREATE FUNCTION round(integer, integer) RETURNS numeric
    LANGUAGE sql
    AS $_$
 SELECT $1::numeric;
$_$;


--
--

CREATE FUNCTION round(bigint, integer) RETURNS numeric
    LANGUAGE sql
    AS $_$
 SELECT $1::numeric;
$_$;


--
--

CREATE FUNCTION round(mpq, integer) RETURNS numeric
    LANGUAGE sql
    AS $_$
SELECT round($1::numeric,$2)
$_$;
