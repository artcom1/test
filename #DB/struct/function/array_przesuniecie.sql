CREATE FUNCTION array_przesuniecie(_array numeric[], _przesuniecie integer) RETURNS numeric[]
    LANGUAGE plpgsql
    AS $$
DECLARE
  _low  INT;
  _upp  INT; 
  wynik NUMERIC[];
BEGIN
 IF (_array IS NULL) THEN RETURN NULL; END IF;
    	
 _low=array_lower(_array,1);
 _upp=array_upper(_array,1);
	
 FOR i IN _low.._upp LOOP
   wynik[i+_przesuniecie]=_array[i];
 END LOOP;

 RETURN wynik;
END
$$;
