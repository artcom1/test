CREATE FUNCTION calcmarzaproc(koszt numeric, wartosc numeric, dokladnosc integer DEFAULT 4) RETURNS numeric
    LANGUAGE sql STABLE
    AS $$
  SELECT round((CASE WHEN wartosc=0 THEN -100 ELSE ((wartosc-koszt)/wartosc)*100 END),dokladnosc);
 $$;
