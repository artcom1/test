CREATE FUNCTION array_translate(_array0 numeric[], _arrayindex integer[]) RETURNS numeric[]
    LANGUAGE plpgsql
    AS $$
DECLARE
  _low         INT;
  _upp         INT; 
  _coalesceVal NUMERIC:=1;
  
  wynik NUMERIC[];
BEGIN
 IF (_arrayIndex IS NULL) THEN RETURN _array0; END IF;
    	
 _low=array_lower(_arrayIndex,1);
 _upp=array_upper(_arrayIndex,1);
	
 FOR i IN _low.._upp LOOP  
  wynik[i]=COALESCE(_array0[_arrayIndex[i]],_coalesceVal);
 END LOOP;

 wynik=array_nullzero(wynik); 
 RETURN wynik;
END
$$;
