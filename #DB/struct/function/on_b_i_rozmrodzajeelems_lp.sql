CREATE FUNCTION on_b_i_rozmrodzajeelems_lp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN 

 IF (nullZero(NEW.rme_lp)=0) THEN
  NEW.rme_lp=nullZero((SELECT max(rme_lp) FROM tg_rozmrodzajeelems WHERE rmr_idrodzaju=NEW.rmr_idrodzaju))+1;
 END IF;
 
 RETURN NEW;
END;
$$;
