CREATE FUNCTION deltavaluenew(v delta) RETURNS numeric
    LANGUAGE sql
    AS $$
    SELECT (CASE WHEN v.id_old IS DISTINCT FROM v.id_new THEN COALESCE(v.value_new,0) ELSE COALESCE(v.value_new,0)-COALESCE(v.value_old,0) END);
   $$;
