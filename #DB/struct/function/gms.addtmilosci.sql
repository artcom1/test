CREATE FUNCTION addtmilosci(v1 tm_ilosci, v2 tm_ilosci) RETURNS tm_ilosci
    LANGUAGE plpgsql
    AS $$
DECLARE
 r gms.tm_ilosci;
BEGIN
 r.pnull=v1.pnull+v2.pnull;
 r.p=v1.p+v2.p;
 r.lnull=v1.lnull+v2.lnull;
 r.l=v1.l+v2.l;
 RETURN r;
END;
$$;
