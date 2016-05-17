CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
 ----KLIENT
 IF ((whereparams&(3<<10))<>0) THEN
  ---Cos powinienem zbierac
  IF (wzidklienta IS NOT NULL) THEN
   IF (pzidklienta IS NOT NULL) THEN
    --WZ not NULL i PZ not NULL
    IF (wzidklienta<>pzidklienta) THEN
     ---Zawsze FALSE
     --      RAISE NOTICE 'FALSE bo rozny klient (dokladnie rozny)';
     RETURN 0;
    END IF;
   ELSE
    --WZ not NULL i PZ NULL
    IF ((whereparams&(1<<15))<>0) THEN
     ---Jesli wymagane dopasowanie to zwroc false
     ---     RAISE NOTICE 'FALSE bo wymagane dokladne dopasowanie';
     RETURN 0;
    ELSE
     ---Zwroc ze niedokladne dopasowanie
     ---      RAISE NOTICE 'COND warunkowe dopasowanie klienta';
     ret=2;
    END IF;
   END IF;
  ELSE
   --WZ NULL
   IF (pzidklienta IS NOT NULL) THEN
    ---      RAISE NOTICE 'FALSE bo na PZecie jest klient';
    RETURN 0;    --- Zwracamy FALSE jesli na PZecie klient jest nieNULLowy
   END IF;
  END IF;
 END IF;  
 
 RETURN ret;
END;
$$;
