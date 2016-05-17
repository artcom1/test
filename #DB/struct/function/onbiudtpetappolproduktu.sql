CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN

 IF (TG_OP='DELETE') THEN
  DELETE FROM tp_mozliwestanowiska WHERE ep_idetapu=OLD.ep_idetapu;
  UPDATE tp_etappolproduktu SET ep_lp=ep_lp-1 WHERE pp_idpolproduktu=OLD.pp_idpolproduktu AND ep_lp>OLD.ep_lp;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
