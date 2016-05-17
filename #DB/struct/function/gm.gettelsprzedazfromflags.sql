CREATE FUNCTION gettelsprzedazfromflags(tel_newflaga integer) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $$
 SELECT (CASE WHEN tel_newflaga&4=4 THEN -1 ELSE 1 END);
$$;
