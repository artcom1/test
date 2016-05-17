CREATE FUNCTION on_b_iud_kkwheadrozm() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
        
 IF (TG_OP<>'DELETE') THEN
  NEW.kwhr_iloscwmag = array_sum(NEW.kwhr_iloscwmag_arr);
  NEW.kwhr_iloscwmagclosed = array_sum(NEW.kwhr_iloscwmagclosed_arr);
  NEW.kwhr_iloscwyk = array_sum(NEW.kwhr_iloscwyk_arr);
  RETURN NEW;
 ELSE
  OLD.kwhr_iloscwmag = array_sum(OLD.kwhr_iloscwmag_arr);
  OLD.kwhr_iloscwmagclosed = array_sum(OLD.kwhr_iloscwmagclosed_arr);
  OLD.kwhr_iloscwyk = array_sum(OLD.kwhr_iloscwyk_arr); 
  RETURN OLD;
 END IF;

END;
$$;
