CREATE FUNCTION kj_iszmianaallowed(idpartii integer, ptm_inkj boolean) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
 SELECT (ptm_inkj=FALSE) OR vendo.gettparami('KJALLOWED_'||idpartii::text,0)>0;
$$;
