CREATE FUNCTION safediv(licznik numeric, mianownik numeric, retonmianownikzero numeric, dokladnosc integer) RETURNS numeric
    LANGUAGE sql IMMUTABLE
    AS $$
 SELECT round((CASE WHEN mianownik=0 THEN retOnMianownikZero ELSE licznik/mianownik END),dokladnosc);
$$;
