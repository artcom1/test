CREATE OR REPLACE FUNCTION 
    LANGUAGE sql
    AS $$
 SELECT vendo.settparami(param,vendo.gettparami(param,defvalue)+delta);
$$;
