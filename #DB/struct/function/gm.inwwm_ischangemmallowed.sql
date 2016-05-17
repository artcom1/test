CREATE OR REPLACE FUNCTION 
    LANGUAGE sql
    AS $$
 SELECT (opencount=0) OR vendo.gettparami('UNLOCKEDMMINV_'||idmiejsca::text,0)>0;
$$;
