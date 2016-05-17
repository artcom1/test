CREATE FUNCTION tesign(_new2flaga integer) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $_$
 SELECT (CASE WHEN ($1&(1<<9))<>0 THEN -1 ELSE 1 END)
$_$;
