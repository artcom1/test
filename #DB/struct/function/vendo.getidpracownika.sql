CREATE FUNCTION getidpracownika() RETURNS integer
    LANGUAGE sql STABLE
    AS $$
 SELECT vendo.gettparami('P_IDPRACOWNIKA');
$$;
