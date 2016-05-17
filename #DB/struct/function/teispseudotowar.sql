CREATE FUNCTION teispseudotowar(new2flaga integer) RETURNS boolean
    LANGUAGE sql STRICT
    AS $$
 SELECT (new2flaga&(1<<30))!=0;
$$;
