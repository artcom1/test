CREATE FUNCTION array_create(_low integer, _upp integer, _val numeric) RETURNS numeric[]
    LANGUAGE plpgsql
    AS $$
DECLARE
  wynik NUMERIC[];
BEGIN
	
 FOR i IN _low.._upp LOOP
   wynik[i]=_val;
 END LOOP;

 RETURN wynik;
END
$$;
