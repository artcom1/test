CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 q TEXT;
 ret INT;
BEGIN

 q=gms.initscex(NULL,NULL,simid::text,idtowmag::text,idruchupz::text);

 q=q||' RETURNING sc_id';

 EXECUTE q INTO ret;

RETURN ret;
END;
$$;
