CREATE FUNCTION isteodwrocona(new2flaga integer) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
 SELECT (new2flaga&(1<<27))!=0;
$$;
