CREATE OR REPLACE FUNCTION 
    LANGUAGE sql STABLE
    AS $$
 SELECT (ptm_inkj=FALSE) OR vendo.gettparami('KJALLOWED_'||idpartii::text,0)>0;
$$;
