CREATE OR REPLACE FUNCTION 
    LANGUAGE sql STRICT
    AS $$
 SELECT (new2flaga&(1<<30))!=0;
$$;
