CREATE OR REPLACE FUNCTION 
    LANGUAGE sql IMMUTABLE
    AS $$
 ---Funkcja zwraca typ ala zestaw dla podanej tel_new2flaga
 SELECT ((tel_new2flaga>>17)&15);
$$;
