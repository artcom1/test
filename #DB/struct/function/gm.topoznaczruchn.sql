CREATE FUNCTION topoznaczruchn() RETURNS bigint
    LANGUAGE sql STABLE
    AS $$
 --- Funkcja zwraca SETID dla aktualnego poziomu
  SELECT COALESCE(vendo.gettparam('ANYOZNACZONYRUCH_TOP')::int8,-1);
 $$;
