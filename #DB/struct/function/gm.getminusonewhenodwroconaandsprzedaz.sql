CREATE OR REPLACE FUNCTION 
    LANGUAGE sql IMMUTABLE
    AS $$
 SELECT (CASE WHEN gm.isTEOdwrocona(tel_new2flaga) AND (gm.getTelSprzedazFromFlags(tel_flaga)=expectedSprzedaz) THEN -1 ELSE 1 END);
$$;
