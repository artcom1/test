CREATE FUNCTION deltavalueold(v delta) RETURNS numeric
    LANGUAGE sql
    AS $$
    SELECT (CASE WHEN v.id_old IS DISTINCT FROM v.id_new THEN COALESCE(v.value_old,0) ELSE 0 END);
   $$;


SET search_path = vat, pg_catalog;