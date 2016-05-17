CREATE FUNCTION istekonsygnaty(new2flaga integer) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
 SELECT (new2flaga&(1<<14))!=0;
$$;
