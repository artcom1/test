CREATE OR REPLACE FUNCTION 
    LANGUAGE sql IMMUTABLE
    AS $_$
 SELECT (CASE WHEN ($1&(1<<12)<>0) THEN 0 ELSE gm.teSign($1) END)
$_$;
