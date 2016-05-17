CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN getMinutesFromSpan($2-$1)-getWorkTime($1,$2,$3);
END
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN getMinutesFromSpan($2-$1)-getWorkTime($1,$2,$3,$4);
END
$_$;
