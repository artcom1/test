CREATE FUNCTION createnewpartialikeother(wzor public.tg_partie, idtowarunew integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN (gmr.findOrCreatePartiaLikeOther(wzor,idtowarunew,true)).prt_idpartii;
END;
$$;
