CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltapointsold NUMERIC:=0;
 deltapointsnew NUMERIC:=0;
BEGIN
 
 IF (TG_OP!='INSERT') THEN
  deltapointsold=deltapointsold+OLD.lem_punktow;
 END IF;

 IF (TG_OP!='DELETE') THEN
  deltapointsnew=deltapointsnew+NEW.lem_punktow;
 END IF;
 
 IF (TG_OP='UPDATE') THEN
  deltapointsnew=deltapointsnew-deltapointsold;
  deltapointsold=0;
 END IF;
 
 IF (deltapointsnew!=0) THEN
  UPDATE tg_losy SET los_pointshas=los_pointshas+deltapointsnew WHERE los_idlosu=NEW.los_idlosu;
  UPDATE tg_losyanaliza SET lan_pktused=lan_pktused+deltapointsnew WHERE lan_idanalizy=NEW.lan_idanalizy;
 END IF;

 IF (deltapointsold!=0) THEN
  UPDATE tg_losy SET los_pointshas=los_pointshas-deltapointsold WHERE los_idlosu=OLD.los_idlosu;
  UPDATE tg_losyanaliza SET lan_pktused=lan_pktused-deltapointsold WHERE lan_idanalizy=OLD.lan_idanalizy;
END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END;
$$;
