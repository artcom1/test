CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN (gmr.findOrCreatePartiaLikeOther(wzor,idtowarunew,true)).prt_idpartii;
END;
$$;
