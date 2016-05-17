CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  IF (TG_OP = 'UPDATE') THEN
   IF (NEW.tr_idtrans <> OLD.tr_idtrans) THEN
      RAISE EXCEPTION 'Nie mozna zmienic transakcji w zapisie konwersjikpir';
    END IF;
  END IF;

  IF (TG_OP = 'DELETE') THEN
   IF (OLD.tr_idtrans>0) THEN
    UPDATE tg_transakcje SET tr_flaga=tr_flaga&(~4194304)&(~32768) WHERE tr_idtrans=OLD.tr_idtrans;
   END IF;
   IF (OLD.am_id>0) THEN
    UPDATE st_amortyzacja SET am_czyksieg=am_czyksieg&(~1) WHERE am_id=OLD.am_id;
   END IF;
   RETURN OLD;
  END IF;

  IF (TG_OP = 'INSERT') THEN
   IF (NEW.tr_idtrans>0) THEN
    UPDATE tg_transakcje SET tr_flaga=tr_flaga|(4194304)|(32768) WHERE tr_idtrans=NEW.tr_idtrans;
   END IF;
   IF (NEW.am_id>0) THEN
    UPDATE st_amortyzacja SET am_czyksieg=am_czyksieg|(1) WHERE am_id=NEW.am_id;
   END IF;

   RETURN NEW;
  END IF;

  IF (TG_OP = 'DELETE') THEN
    RETURN OLD;
  END IF;
 
  RETURN NEW;
END;$$;
