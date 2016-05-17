CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='UPDATE') THEN

  IF (NEW.ttw_vats<>OLD.ttw_vats) THEN
   UPDATE tg_ceny SET tcn_valuebrt=round(Net2Brt(tcn_value,NEW.ttw_vats),tcn_dokladnosc) WHERE (ttw_idtowaru=NEW.ttw_idtowaru) AND (tgc_idgrupy IN (SELECT tgc_idgrupy FROM ts_grupycen WHERE tgc_flaga&4=0));
   UPDATE tg_ceny SET tcn_value=round(Brt2Net(tcn_valuebrt,NEW.ttw_vats),tcn_dokladnosc) WHERE (ttw_idtowaru=NEW.ttw_idtowaru) AND (tgc_idgrupy IN (SELECT tgc_idgrupy FROM ts_grupycen WHERE tgc_flaga&4=4));
  END IF;

 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
