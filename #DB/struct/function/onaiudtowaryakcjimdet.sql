CREATE FUNCTION onaiudtowaryakcjimdet() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 DECLARE
  deltaold     NUMERIC:=0;
  deltanew     NUMERIC:=0;
  limitklienta NUMERIC:=0;
 BEGIN
 
  IF (TG_OP<>'INSERT') THEN
   deltaold=deltaold-OLD.tam_ilosccurrent;
  END IF;
 
  IF (TG_OP<>'DELETE') THEN
   deltanew=deltanew+NEW.tam_ilosccurrent;
  END IF;
  
  IF (TG_OP='UPDATE') THEN
   deltanew=deltanew+deltaold;
   deltaold=0;
  END IF;

  IF (TG_OP<>'DELETE') AND (deltanew>0) THEN
   limitklienta=(SELECT ta_iloscmaxperklient FROM tg_towaryakcjim WHERE ta_idtowaru=NEW.ta_idtowaru);
   IF (limitklienta IS NOT NULL AND (NEW.tam_ilosccurrent+deltanew>limitklienta)) THEN
    PERFORM vendo.addOrder('SELECT checkLimitTowarOnAkcja('||NEW.ta_idtowaru||','||NEW.k_idklienta||')');
   END IF;
  END IF;
  
  
  IF (deltaold<>0) THEN
   UPDATE tg_towaryakcjim SET ta_ilosccurrent=ta_ilosccurrent+deltaold WHERE ta_idtowaru=OLD.ta_idtowaru;
   deltaold=0;
  END IF;

  IF (deltanew<>0) THEN
   UPDATE tg_towaryakcjim SET ta_ilosccurrent=ta_ilosccurrent+deltanew WHERE ta_idtowaru=NEW.ta_idtowaru;
   deltanew=0;
  END IF;

  
  IF (TG_OP='DELETE') THEN
   RETURN OLD;
  END IF;
  
  RETURN NEW;
 END;
$$;
