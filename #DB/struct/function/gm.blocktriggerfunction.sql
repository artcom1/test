CREATE OR REPLACE FUNCTION 
    LANGUAGE sql STABLE
    AS $$
 SELECT (CASE WHEN id IS NULL THEN vendo.deltatparami(fName::text,delta,0) ELSE vendo.deltatparami(fName::text||'_'||id::text,delta,0) END)=0;
$$;
