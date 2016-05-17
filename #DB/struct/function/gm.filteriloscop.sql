CREATE FUNCTION filteriloscop(iloscop numeric, new2flaga integer) RETURNS numeric
    LANGUAGE sql IMMUTABLE
    AS $$
 SELECT (CASE WHEN (new2flaga&(1<<21))!=0 THEN NULL ELSE iloscop END);
$$;
