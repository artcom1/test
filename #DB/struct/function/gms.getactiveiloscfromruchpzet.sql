CREATE FUNCTION getactiveiloscfromruchpzet(rc_flaga integer, rc_iloscpoz numeric, rc_iloscwzbuf numeric) RETURNS numeric
    LANGUAGE sql IMMUTABLE
    AS $$
 SELECT (CASE WHEN gms.isActiveRuchPZet(rc_flaga)=FALSE THEN 0 ELSE rc_iloscpoz+rc_iloscwzbuf END);
$$;
