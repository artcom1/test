CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='UPDATE') THEN
 
  IF (NEW.ta_ilosccurrent>NEW.ta_iloscmax) THEN
   PERFORM vendo.addOrder('SELECT checkLimitTowarOnAkcja('||NEW.ta_idtowaru||')');
  END IF;
 
 END IF;

 RETURN NEW;
END;
$$;
