CREATE FUNCTION kkwnodobliczilosc_array(numeric[], numeric[], numeric[], numeric, numeric, integer, integer, numeric) RETURNS numeric[]
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _wykonano     ALIAS FOR $1;
 _brakow       ALIAS FOR $2;
 _wystepowanie ALIAS FOR $3;
 _licznik      ALIAS FOR $4;
 _mianownik    ALIAS FOR $5;
 _flaga        ALIAS FOR $6;
 _knr_flaga    ALIAS FOR $7;
 _knr_iloscmin ALIAS FOR $8;
 
 _min_low   INT;
 _max_upp   INT;
 
 ile        NUMERIC;
 ret        NUMERIC[];
BEGIN

 IF (_knr_flaga&16=16) THEN
  RETURN NULL;
 END IF;

 IF (_mianownik=0) THEN
  _mianownik=1;
 END IF;

 _knr_iloscmin=0;
 
 _min_low=min(array_lower(_wykonano,1),array_lower(_wystepowanie,1));
 _max_upp=max(array_upper(_wykonano,1),array_upper(_wystepowanie,1));
 
--- _min_low=min(_min_low,array_lower(_wystepowanie,1));
--- _max_upp=max(_max_upp,);
 
 IF (_min_low IS NULL OR _max_upp IS NULL) THEN
  RETURN NULL;
 END IF;
 
 FOR i IN _min_low.._max_upp LOOP
  ile=COALESCE(_wykonano[i],0);
  IF (_flaga&3=0) THEN    -- Uwzglednij braki 
   ile=ile+COALESCE(_brakow[i],0);
  END IF;
  IF (_flaga&3=2) THEN    -- Tylko braki
   ile=COALESCE(_brakow[i],0);
  END IF;
 
  ile=round(ile*COALESCE(_licznik,0)/COALESCE(_mianownik,1),4);
  ile=ile*_wystepowanie[i];
  ret[i]=max(COALESCE(ile,0),_knr_iloscmin);
 END LOOP;

 RETURN ret;
END;
$_$;
