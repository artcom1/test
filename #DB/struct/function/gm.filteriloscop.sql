CREATE OR REPLACE FUNCTION 
    LANGUAGE sql IMMUTABLE
    AS $$
 SELECT (CASE WHEN (new2flaga&(1<<21))!=0 THEN NULL ELSE iloscop END);
$$;
