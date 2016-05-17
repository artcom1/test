CREATE FUNCTION getdefmvpage() RETURNS integer
    LANGUAGE sql
    AS $$
 SELECT min(mvg_id) FROM mv.ts_multivalpage;
$$;
