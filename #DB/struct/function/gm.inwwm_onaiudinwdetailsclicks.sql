CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF (TG_OP='INSERT') THEN
  IF (NEW.ind_iloscf>0) THEN
     INSERT INTO tg_inwdetailclicks (ind_id, ine_id, tr_idtrans, p_idpracownika, inc_iloscf, prt_idpartii, mm_idmiejsca) VALUES (NEW.ind_id, NEW.ine_id, NEW.tr_idtrans, vendo.getidpracownika(), NEW.ind_iloscf,NEW.prt_idpartiipz, NEW.mm_idmiejsca); 
  END IF;
 END IF;
 
 IF (TG_OP='UPDATE') THEN
  IF (NEW.ind_iloscf<>OLD.ind_iloscf) THEN
     INSERT INTO tg_inwdetailclicks (ind_id, ine_id, tr_idtrans, p_idpracownika, inc_iloscf, prt_idpartii, mm_idmiejsca) VALUES (NEW.ind_id, NEW.ine_id, NEW.tr_idtrans, vendo.getidpracownika(), NEW.ind_iloscf-OLD.ind_iloscf,NEW.prt_idpartiipz,NEW.mm_idmiejsca); 
  END IF;
 END IF;
 
	
 RETURN NEW; 
END;
$$;
