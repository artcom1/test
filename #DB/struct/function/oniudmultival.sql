CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF (TG_OP='INSERT') THEN
  IF NEW.v_flaga&2=0 THEN
   NEW.v_type=(SELECT mv_type FROM ts_multivalues WHERE mv_idvalue=NEW.mv_idvalue);
  ELSE
   IF nullZero(NEW.v_type)=0 THEN
    RAISE EXCEPTION 'Brak typu dla wartosci dowolnej!'; 
   END IF;
  END IF;
 END IF;
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
