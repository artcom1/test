CREATE OR REPLACE FUNCTION 
    LANGUAGE sql
    AS $$
 ---Zwraca identyfikator SETa ponadto tworzac tabele
 SELECT nextval('gm.oznaczpartie_s') + min(gm.createoznaczruchytable()::int,0)::int;
$$;
