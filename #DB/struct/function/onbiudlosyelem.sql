CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='INSERT') THEN
  NEW.tr_idtrans=(SELECT te.tr_idtrans FROM tg_losyanaliza AS a JOIN tg_transelem AS te ON (te.tel_idelem=a.tel_idelem) WHERE a.lan_idanalizy=NEW.lan_idanalizy);
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END;
$$;
