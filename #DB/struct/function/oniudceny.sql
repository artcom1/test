CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 ischangednetto BOOL:=TRUE;
BEGIN

 IF (TG_OP!='DELETE') THEN
  NEW.tcn_value=round(NEW.tcn_value,NEW.tcn_dokladnosc);
  NEW.tcn_valuebrt=round(NEW.tcn_valuebrt,NEW.tcn_dokladnosc);
 END IF;

 IF (TG_OP='UPDATE') THEN
  ischangednetto=FALSE;  
  IF (NEW.tcn_value<>OLD.tcn_value) OR (NEW.tcn_idwaluty<>OLD.tcn_idwaluty) OR (NEW.tcn_isdefault<>OLD.tcn_isdefault) THEN
   ischangednetto=TRUE;
  END IF;

  IF (NEW.tcn_value<>OLD.tcn_value) OR (NEW.tcn_valuebrt<>OLD.tcn_valuebrt) OR (NEW.tcn_idwaluty<>OLD.tcn_idwaluty) THEN
   NEW.tcn_lastchange=now();
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  IF (NEW.tcn_isdefault=TRUE) AND (ischangednetto=TRUE) THEN
   UPDATE tg_towary SET ttw_cenadef=NEW.tcn_value,ttw_wlcenadef=NEW.tcn_idwaluty WHERE ttw_idtowaru=NEW.ttw_idtowaru;
  END IF;
  IF (NEW.tgc_idgrupy=4) AND (ischangednetto=TRUE) THEN
   UPDATE tg_towary SET ttw_cenabaz=NEW.tcn_value,ttw_idwalutybaz=NEW.tcn_idwaluty WHERE ttw_idtowaru=NEW.ttw_idtowaru;
  END IF;

  PERFORM UpdateRecChange(10,NEW.ttw_idtowaru);

 END IF;

 IF (TG_OP='DELETE') THEN
  IF (OLD.tcn_isdefault=TRUE) THEN
   UPDATE tg_towary SET ttw_cenadef=0,ttw_wlcenadef=1 WHERE ttw_idtowaru=OLD.ttw_idtowaru;
  END IF;
  IF (OLD.tgc_idgrupy=4) THEN
   UPDATE tg_towary SET ttw_cenabaz=0,ttw_idwalutybaz=1 WHERE ttw_idtowaru=OLD.ttw_idtowaru;
  END IF;

  PERFORM UpdateRecChange(10,OLD.ttw_idtowaru);

 END IF;

 ------odkladamy zmiane cen do trigerow programu by moc przeliczyc inne zmiany cen
 IF (TG_OP='INSERT') THEN
  PERFORM vendo.addOnBeforeCommitOrder(2,NEW.tgc_idgrupy::text||'|'||NEW.ttw_idtowaru::text||'|'||NEW.tcn_value::text||'|'||NEW.tcn_idwaluty::text);
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NEW.tcn_value!=OLD.tcn_value OR NEW.tcn_valuebrt!=OLD.tcn_valuebrt OR NEW.tcn_idwaluty!=OLD.tcn_idwaluty) THEN 
   PERFORM vendo.addOnBeforeCommitOrder(2,NEW.tgc_idgrupy::text||'|'||NEW.ttw_idtowaru::text||'|'||NEW.tcn_value::text||'|'||NEW.tcn_idwaluty::text);
   RAISE NOTICE ':INVO: 169,%',NEW.tcn_idceny;
  END IF;
 END IF;
 ----koniec odkladania zmian cen do trigerow programu

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
