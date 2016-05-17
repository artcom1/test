CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
  licz      ALIAS FOR $1;
  mian      ALIAS FOR $2;
  dzialanie ALIAS FOR $3;
  -- 1 plus
  -- 2 multi
  -- 3 minus
  -- 4 div
  _min_low  INT;
  _max_upp  INT; 
  wynik     NUMERIC[];
BEGIN
 IF (licz IS NULL) THEN RETURN mian; END IF;
 IF (mian IS NULL) THEN RETURN licz; END IF;
    	
 _min_low=min(array_lower(licz,1),array_lower(mian,1));
 _max_upp=max(array_upper(licz,1),array_upper(mian,1));
	
 FOR i IN _min_low.._max_upp LOOP
  CASE 
  WHEN dzialanie=1 THEN
   -- 1 plus
   wynik[i]=NullZero(licz[i])+NullZero(mian[i]);
  WHEN dzialanie=2 THEN
   -- 2 multi
   wynik[i]=(NullZero(licz[i])*NullZero(mian[i]));
  WHEN dzialanie=3 THEN
   -- 3 minus
   wynik[i]=NullZero(licz[i])-NullZero(mian[i]);
  WHEN dzialanie=4 THEN
   -- 4 div
   IF (NullZero(mian[i]) <> 0) THEN
    wynik[i]=(NullZero(licz[i])/NullZero(mian[i]));
   ELSE
    wynik[i]=NULL;
   END IF;
  ELSE
   RAISE NOTICE 'Dzialanie % nie zdefiniowane!', dzialanie;
   RETURN NULL;
  END CASE;
 END LOOP;

 RETURN wynik;
END
$_$;
