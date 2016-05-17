CREATE OR REPLACE FUNCTION 
    LANGUAGE sql STABLE
    AS $$
  SELECT round((CASE WHEN koszt=0 THEN 100 ELSE ((wartosc-koszt)/koszt)*100 END),dokladnosc);
 $$;
