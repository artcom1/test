CREATE FUNCTION getidcentrali() RETURNS integer
    LANGUAGE sql STABLE
    AS $$
 SELECT vendo.gettparami('FM_IDCENTRALI');
$$;
