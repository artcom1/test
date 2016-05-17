CREATE FUNCTION getminusonewhenodwroconaandsprzedaz(tel_flaga integer, tel_new2flaga integer, expectedsprzedaz integer) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $$
 SELECT (CASE WHEN gm.isTEOdwrocona(tel_new2flaga) AND (gm.getTelSprzedazFromFlags(tel_flaga)=expectedSprzedaz) THEN -1 ELSE 1 END);
$$;
