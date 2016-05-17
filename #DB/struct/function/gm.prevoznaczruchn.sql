CREATE FUNCTION prevoznaczruchn(bigint DEFAULT topoznaczruchn()) RETURNS bigint
    LANGUAGE sql STABLE
    AS $_$
 --- Funkcja zwraca SETID dla poprzedniego poziomu
  SELECT COALESCE(vendo.gettparam('ANYOZNACZONYRUCH_PREV_'||COALESCE($1,-1)::text)::int8,-1);
 $_$;
