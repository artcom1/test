CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE 
 _th_idtechnologii INT;
BEGIN
 -- Sprawdzam czy w ogole mamy do czynienia z robocizna na kalkulacji
 IF (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
  _th_idtechnologii=NEW.th_idtechnologii;
 ELSE -- Mamy DELETE
  _th_idtechnologii=OLD.th_idtechnologii;
 END IF;
 
 PERFORM update_mrpkalkulacjaobliczkoszty(_th_idtechnologii); 
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
