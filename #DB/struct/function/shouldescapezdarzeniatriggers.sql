CREATE FUNCTION shouldescapezdarzeniatriggers() RETURNS boolean
    LANGUAGE sql
    AS $$
 SELECT vendo.getTParamI('RETZDARZENIETRIGGERS',0)>0;
$$;
