CREATE FUNCTION checkroznevalue(typ integer, rodzaj integer, valueno integer, valueexpected text) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
 SELECT (SELECT rn_idrozne FROM ts_rozne WHERE rn_typ=typ AND rn_id=rodzaj AND rn_value=valueno::text||'_'||valueexpected LIMIT 1) IS NOT NULL
$$;
