CREATE FUNCTION narrow(v1 tm_ilosci) RETURNS tm_ilosci
    LANGUAGE plpgsql
    AS $$
BEGIN
 v1.pnull=COALESCE(v1.pnull,0);
 v1.p=COALESCE(v1.p,0);
 v1.lnull=COALESCE(v1.lnull,0);
 v1.l=COALESCE(v1.l,0);
 RETURN v1;
END;
$$;
