CREATE FUNCTION flc_compare(x tm_flagcounterbase, y tm_flagcounterbase) RETURNS boolean
    LANGUAGE sql
    AS $$
 SELECT x IS NOT DISTINCT FROM y;
$$;
