CREATE FUNCTION on_b_iu_kkwhead_rozmiarowka() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (NEW.kwh_towary IS NULL) THEN
  RETURN NEW;
 END IF;  
 
 IF (TG_OP='UPDATE') THEN
  IF (OLD.kwh_iloscoczek_array=NEW.kwh_iloscoczek_array AND OLD.kwh_iloscwyk_array=NEW.kwh_iloscwyk_array) THEN
   RETURN NEW;
  END IF;
 END IF; 
  
 IF (TG_OP='INSERT') THEN
  IF (NEW.kwh_iloscoczek_array IS NULL AND NEW.kwh_iloscoczek_array IS NULL) THEN
   RETURN NEW;
  END IF; 
 END IF;
  
  NEW.kwh_iloscoczek_array=array_round(array_normalize(NEW.kwh_towary, NEW.kwh_iloscoczek_array),4);
  NEW.kwh_iloscoczek=nullzero(array_sum(NEW.kwh_iloscoczek_array));
  
  NEW.kwh_iloscwyk_array=array_round(array_normalize(NEW.kwh_towary, NEW.kwh_iloscwyk_array),4);
  NEW.kwh_iloscwyk=nullzero(array_sum(NEW.kwh_iloscwyk_array));
  
 RETURN NEW;
END;
$$;
