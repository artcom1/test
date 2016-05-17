CREATE OR REPLACE FUNCTION 
    LANGUAGE sql IMMUTABLE
    AS $$
 SELECT vendo.getConfigValue('MMagWspolne')='1';
$$;
