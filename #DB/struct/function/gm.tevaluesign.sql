CREATE FUNCTION tevaluesign(_new2flaga integer) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $_$
 SELECT (CASE WHEN ($1&(1<<12)<>0) THEN 0 ELSE gm.teSign($1) END)
$_$;
