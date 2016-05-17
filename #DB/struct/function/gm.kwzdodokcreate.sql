CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN gm.kmagtokhandcreate(_idtrans,_idkor,_movekgo,-1); 
END;
$$;
