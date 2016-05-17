CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (NEW.tr_zamknieta&1=1) THEN
  UPDATE tg_ruchy SET rc_flaga=(rc_flaga&(~(1<<28)))|16384 WHERE tr_idtrans=NEW.tr_idtrans AND (rc_flaga&(1<<28))!=0;
 ELSE
  UPDATE tg_ruchy SET rc_flaga=(rc_flaga|(1<<28))|16384 WHERE tr_idtrans=NEW.tr_idtrans AND (rc_flaga&(1<<28))=0;
 END IF;


 RETURN NEW;
END;
$$;
