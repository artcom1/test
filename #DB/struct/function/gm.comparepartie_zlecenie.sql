CREATE FUNCTION comparepartie_zlecenie(ret integer, whereparams integer, pzidzlecenia integer, wzidzlecenia integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
 ----ZLECENIE
 IF ((whereparams&(1<<12))<>0) THEN
  ---Cos powinienem zbierac
  IF (wzidzlecenia IS NOT NULL) THEN
   IF (pzidzlecenia IS NOT NULL) THEN
    --WZ not NULL i PZ not NULL
    IF (wzidzlecenia<>pzidzlecenia) THEN
     ---Zawsze FALSE
     ---      RAISE NOTICE 'FALSE bo rozny zlecenie (dokladnie rozny)';
     RETURN 0;
    END IF;
   ELSE
    --WZ not NULL i PZ NULL
    IF ((whereparams&(1<<16))<>0) THEN
     ---Jesli wymagane dopasowanie to zwroc false
     ---      RAISE NOTICE 'FALSE bo wymagane dokladne dopasowanie zlecenia';
     RETURN 0;
    ELSE
     ---Zwroc ze niedokladne dopasowanie
     ---      RAISE NOTICE 'COND warunkowe dopasowanie zlecenia';
     ret=2;
    END IF;
   END IF;
  ELSE
   --WZ NULL
   IF (pzidzlecenia IS NOT NULL) THEN
    ---      RAISE NOTICE 'FALSE bo na PZecie jest zlecenie';
    RETURN 0;    --- Zwracamy FALSE jesli na PZecie klient jest nieNULLowy
   END IF;
  END IF;
 END IF;  

 RETURN ret;
END;
$$;
