CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
 
 IF (COALESCE(OLD.kwh_standomyslne,0)<>COALESCE(NEW.kwh_standomyslne,0)) THEN   
  RAISE NOTICE 'on_a_u_kkwhead_dyspozycja: NEW=% OLD=%',NEW.kwh_standomyslne, OLD.kwh_standomyslne;  
  IF (COALESCE(NEW.kwh_standomyslne,0)>0) THEN
   UPDATE tr_kkwnod SET kwe_stanowiskoplan=NEW.kwh_standomyslne, kwe_flaga=kwe_flaga|(1<<14) WHERE kwh_idheadu=NEW.kwh_idheadu;
  ELSE
   UPDATE tr_kkwnod SET kwe_flaga=kwe_flaga&(~(1<<14)) WHERE kwh_idheadu=NEW.kwh_idheadu;
  END IF;
 END IF;
  
 RETURN NEW;
END;
$$;
