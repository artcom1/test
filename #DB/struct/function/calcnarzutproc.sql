CREATE FUNCTION calcnarzutproc(koszt numeric, wartosc numeric, dokladnosc integer DEFAULT 4) RETURNS numeric
    LANGUAGE sql STABLE
    AS $$
  SELECT round((CASE WHEN koszt=0 THEN 100 ELSE ((wartosc-koszt)/koszt)*100 END),dokladnosc);
 $$;
