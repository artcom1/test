CREATE FUNCTION deltatparami(param text, delta integer, defvalue integer DEFAULT 0) RETURNS integer
    LANGUAGE sql
    AS $$
 SELECT vendo.settparami(param,vendo.gettparami(param,defvalue)+delta);
$$;
