CREATE OR REPLACE FUNCTION 
    LANGUAGE sql
    AS $$
 SELECT (a.pnull+b.pnull,a.p+b.p,a.lnull+b.lnull,a.l+b.l)::gms.tm_ilosci;
$$;
