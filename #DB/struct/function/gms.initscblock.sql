CREATE FUNCTION initscblock(tablequery text, tablealias text, simid text, idtowmag text, idruchupz text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
 q TEXT;
 ret INT;
BEGIN
 q=gms.initscex(tablequery,tablealias,simid,idtowmag,idruchupz);

 EXECUTE q;

 RETURN TRUE;
END;
$$;
