CREATE OR REPLACE FUNCTION 
    LANGUAGE sql
    AS $$
 SELECT (a.pnull+a.lnull,a.p+a.l,0,0)::gms.tm_ilosci;
$$;
