CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE 
 _th_idtechnologii INT;
BEGIN
 -- Sprawdzam czy w ogole mamy do czynienia z robocizna na kalkulacji
 IF (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
  IF ((NEW.the_flaga&(1<<17))=(1<<17)) THEN 
   _th_idtechnologii=NEW.th_idtechnologii;
  ELSE
   RETURN NEW; 
  END IF;   
 ELSE -- Mamy DELETE
  IF ((OLD.the_flaga&(1<<17))=(1<<17)) THEN 
   _th_idtechnologii=OLD.th_idtechnologii;
  ELSE
   RETURN OLD; 
  END IF;   
 END IF;
 
 PERFORM update_mrpkalkulacjaobliczkoszty(_th_idtechnologii); 
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
