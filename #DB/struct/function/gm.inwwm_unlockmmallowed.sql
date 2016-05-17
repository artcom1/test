CREATE OR REPLACE FUNCTION 
    LANGUAGE sql
    AS $$
 SELECT vendo.deltatparami('UNLOCKEDMMINV_'||idmiejsca::text,delta,0);
$$;
