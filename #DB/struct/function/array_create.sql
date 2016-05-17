CREATE OR REPLACE FUNCTION 
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
