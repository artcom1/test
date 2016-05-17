CREATE FUNCTION getminusonewhenodwrocona(tel_new2flaga integer) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $$
 SELECT (CASE WHEN gm.isTEOdwrocona(tel_new2flaga) THEN -1 ELSE 1 END);
$$;
