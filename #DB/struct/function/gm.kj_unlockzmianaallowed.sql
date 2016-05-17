CREATE OR REPLACE FUNCTION 
    LANGUAGE sql
    AS $$
 SELECT vendo.deltatparami('KJALLOWED_'||idpartii::text,delta,0);
$$;
