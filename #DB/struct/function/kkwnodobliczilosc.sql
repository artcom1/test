CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _wykonano  ALIAS FOR $1;
 _brakow    ALIAS FOR $2;
 _licznik   ALIAS FOR $3;
 _mianownik ALIAS FOR $4;
 _flaga     ALIAS FOR $5;
 ile        NUMERIC:=0;
BEGIN

 ile=COALESCE(_wykonano,0);

 IF (_flaga&3=0) THEN    -- Uwzglednij braki 
  ile=ile+COALESCE(_brakow,0);
 END IF;
 IF (_flaga&3=2) THEN    -- Tylko braki
  ile=COALESCE(_brakow,0);
 END IF;

 IF (_mianownik=0) THEN
  _mianownik=1;
 END IF;
 
 ile=round(ile*COALESCE(_licznik,0)/COALESCE(_mianownik,1),4);

 RETURN ile;
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _wykonano  ALIAS FOR $1;
 _brakow    ALIAS FOR $2;
 _licznik   ALIAS FOR $3;
 _mianownik ALIAS FOR $4;
 _flaga     ALIAS FOR $5;
 _knr_flaga ALIAS FOR $6;
 ile        NUMERIC:=0;
BEGIN

 IF (_knr_flaga&16=16) THEN
  RETURN 0;
 END IF;

 ile=COALESCE(_wykonano,0);

 IF (_flaga&3=0) THEN    -- Uwzglednij braki 
  ile=ile+COALESCE(_brakow,0);
 END IF;
 IF (_flaga&3=2) THEN    -- Tylko braki
  ile=COALESCE(_brakow,0);
 END IF;

 IF (_mianownik=0) THEN
  _mianownik=1;
 END IF;
 
 ile=round(ile*COALESCE(_licznik,0)/COALESCE(_mianownik,1),4);

 RETURN ile;
END;
$_$;
