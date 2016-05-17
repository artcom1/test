CREATE OR REPLACE FUNCTION 
    LANGUAGE sql IMMUTABLE
    AS $$
 SELECT round((CASE WHEN mianownik=0 THEN retOnMianownikZero ELSE licznik/mianownik END),dokladnosc);
$$;
