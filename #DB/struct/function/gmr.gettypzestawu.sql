CREATE FUNCTION gettypzestawu(tel_new2flaga integer) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $$
 ---Funkcja zwraca typ ala zestaw dla podanej tel_new2flaga
 SELECT ((tel_new2flaga>>17)&15);
$$;
