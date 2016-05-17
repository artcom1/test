CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 ile INT:=0;
BEGIN

 IF (TG_OP='INSERT') THEN
  NEW.cv_srcrodzaj=(SELECT tr_rodzaj FROM tg_transakcje WHERE tr_idtrans=NEW.cv_src LIMIT 1 OFFSET 0);
  NEW.cv_destrodzaj=(SELECT tr_rodzaj FROM tg_transakcje WHERE tr_idtrans=NEW.cv_dest LIMIT 1 OFFSET 0);
  UPDATE tg_transakcje SET tr_flaga=tr_flaga|4 WHERE tr_idtrans=NEW.cv_dest;
  IF (NEW.cv_destrodzaj=103) THEN
   UPDATE tg_transakcje SET tr_flaga=tr_flaga|(1<<21) WHERE tr_idtrans=NEW.cv_src;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  IF (OLD.cv_destrodzaj=103) THEN
   ile=(SELECT count(*) FROM tg_konwersje WHERE cv_destrodzaj=103 AND cv_src=OLD.cv_src AND cv_dest!=OLD.cv_dest);
   IF (ile=0) THEN
    UPDATE tg_transakcje SET tr_flaga=tr_flaga&(~(1<<21)) WHERE tr_idtrans=OLD.cv_src;
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
