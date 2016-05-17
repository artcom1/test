CREATE OR REPLACE FUNCTION 
    LANGUAGE sql
    AS $$
 SELECT min(mvg_id) FROM mv.ts_multivalpage;
$$;
