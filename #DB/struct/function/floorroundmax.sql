CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN min(round($1,2),$2);
END
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN min(round($1,2),$2);
END
$_$;
