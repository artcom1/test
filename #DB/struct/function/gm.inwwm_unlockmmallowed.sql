CREATE FUNCTION inwwm_unlockmmallowed(idmiejsca integer, delta integer) RETURNS integer
    LANGUAGE sql
    AS $$
 SELECT vendo.deltatparami('UNLOCKEDMMINV_'||idmiejsca::text,delta,0);
$$;
