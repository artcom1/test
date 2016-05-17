CREATE FUNCTION kwzdodokcreate(_idtrans integer, _idkor integer, _movekgo boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
 RETURN gm.kmagtokhandcreate(_idtrans,_idkor,_movekgo,-1); 
END;
$$;
