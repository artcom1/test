CREATE OR REPLACE FUNCTION 
    LANGUAGE sql IMMUTABLE
    AS $$
 SELECT (rc_flaga&(1<<28)!=0 OR isAPZet(rc_flaga))=FALSE;
$$;
