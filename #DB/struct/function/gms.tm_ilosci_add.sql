CREATE FUNCTION tm_ilosci_add(a tm_ilosci, b tm_ilosci) RETURNS tm_ilosci
    LANGUAGE sql
    AS $$
 SELECT (a.pnull+b.pnull,a.p+b.p,a.lnull+b.lnull,a.l+b.l)::gms.tm_ilosci;
$$;
