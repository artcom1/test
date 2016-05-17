CREATE OR REPLACE FUNCTION 
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
