CREATE OR REPLACE FUNCTION 
    LANGUAGE sql IMMUTABLE
    AS $$
 SELECT (CASE WHEN gms.isActiveRuchPZet(rc_flaga)=FALSE THEN 0 ELSE rc_iloscpoz+rc_iloscwzbuf END);
$$;
