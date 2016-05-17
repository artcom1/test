CREATE FUNCTION hasmiejscamagazynowewspolne() RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
 SELECT vendo.getConfigValue('MMagWspolne')='1';
$$;
