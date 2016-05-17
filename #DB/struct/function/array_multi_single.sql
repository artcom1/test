CREATE FUNCTION array_multi_single(numeric[], numeric) RETURNS numeric[]
    LANGUAGE plpgsql
    AS $_$
DECLARE
  wynik NUMERIC[];
  czynnik_l   ALIAS FOR $1;
  czynnik_single   ALIAS FOR $2;
BEGIN
 IF (czynnik_l IS NULL OR czynnik_single IS NULL) THEN
   RETURN NULL;
  END IF;
  FOR i IN array_lower( czynnik_l,1 )..array_upper( czynnik_l,1 ) LOOP   
    wynik[i]=(czynnik_l[i]*czynnik_single);    
  END LOOP;

  RETURN wynik;
END
$_$;
