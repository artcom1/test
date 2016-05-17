CREATE FUNCTION inwwm_ischangemmallowed(idmiejsca integer, opencount integer) RETURNS boolean
    LANGUAGE sql
    AS $$
 SELECT (opencount=0) OR vendo.gettparami('UNLOCKEDMMINV_'||idmiejsca::text,0)>0;
$$;
