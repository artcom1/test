CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='DELETE') THEN
  UPDATE gms.tm_simcoll SET  sc_ilosc[0]=sc_ilosc[0]-(OLD.swz_iloscrest_pnull,OLD.swz_iloscrest_p,0,0),
         sc_iloscpoz=sc_iloscpoz+OLD.swz_iloscpozondel,
		 sc_iloscpriorited=sc_iloscpriorited+OLD.swz_iloscpriorondel
  WHERE sc_id=OLD.sc_id;
 END IF;

 IF (TG_OP='UPDATE') THEN
  UPDATE gms.tm_simcoll SET  sc_ilosc[0]=sc_ilosc[0]+(NEW.swz_iloscrest_pnull-OLD.swz_iloscrest_pnull,NEW.swz_iloscrest_p-OLD.swz_iloscrest_p,0,0)
  WHERE sc_id=NEW.sc_id;
 END IF;


 IF (TG_OP='INSERT') THEN
  UPDATE gms.tm_simcoll SET  sc_ilosc[0]=sc_ilosc[0]+(NEW.swz_iloscrest_pnull,NEW.swz_iloscrest_p,0,0)
  WHERE sc_id=NEW.sc_id;
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
