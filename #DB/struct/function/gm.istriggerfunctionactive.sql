CREATE FUNCTION istriggerfunctionactive(fname triggerfunction, id integer DEFAULT NULL::integer) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
 SELECT ((CASE WHEN id IS NULL THEN vendo.gettparami(COALESCE(fName::text,''),0) ELSE vendo.gettparami(COALESCE(fName::text||'_'||id::text,''),0) END)=0);
$$;
