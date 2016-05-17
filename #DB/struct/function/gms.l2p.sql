CREATE FUNCTION l2p(a tm_ilosci) RETURNS tm_ilosci
    LANGUAGE sql
    AS $$
 SELECT (a.pnull+a.lnull,a.p+a.l,0,0)::gms.tm_ilosci;
$$;
