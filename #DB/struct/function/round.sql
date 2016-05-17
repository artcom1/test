CREATE OR REPLACE FUNCTION 
    LANGUAGE sql
    AS $_$
 SELECT $1::numeric;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE sql
    AS $_$
 SELECT $1::numeric;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE sql
    AS $_$
SELECT round($1::numeric,$2)
$_$;
