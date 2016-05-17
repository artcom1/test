CREATE FUNCTION addmrppaletasafeflag(f integer) RETURNS integer
    LANGUAGE sql
    AS $$
 SELECT f|(1<<30);
$$;
