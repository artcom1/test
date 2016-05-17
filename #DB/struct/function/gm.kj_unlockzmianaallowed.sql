CREATE FUNCTION kj_unlockzmianaallowed(idpartii integer, delta integer) RETURNS integer
    LANGUAGE sql
    AS $$
 SELECT vendo.deltatparami('KJALLOWED_'||idpartii::text,delta,0);
$$;
