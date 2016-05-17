CREATE FUNCTION getznaczeniezestawu(tel_new2flaga integer) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $$
 ---Funkcja zwraca typ ala zestaw dla podanej tel_new2flaga
 SELECT ((tel_new2flaga>>15)&3);
$$;
