CREATE FUNCTION isoznaczonyruchn(idruchu integer) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
 --- Funkcja zwraca TRUE jesli ruch o ID=idruchu jest oznaczony na najwyzszym SETID
 SELECT gm.isAnyOznaczonyRuchN(NULL) AND EXISTS ( SELECT ozr_id FROM gm.tm_oznaczoneruchy WHERE rc_idruchu=idruchu AND ozr_setid=gm.topOznaczRuchN() LIMIT 1);
$$;
