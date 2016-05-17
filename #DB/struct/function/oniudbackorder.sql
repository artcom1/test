CREATE FUNCTION oniudbackorder() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltaplusold NUMERIC:=0;
 deltaminusold NUMERIC:=0;
 deltaplusnew NUMERIC:=0;
 deltaminusnew NUMERIC:=0;
BEGIN

 IF (TG_OP<>'INSERT') THEN
  IF (isBORDERPlus(OLD.bo_flaga)) THEN
   deltaplusold=deltaplusold-OLD.bo_iloscf;
  ELSE
   deltaminusold=deltaminusold-OLD.bo_iloscf;
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  IF (isBORDERPlus(NEW.bo_flaga)) THEN
   deltaplusnew=deltaplusnew+NEW.bo_iloscf;
  ELSE
   deltaminusnew=deltaminusnew+NEW.bo_iloscf;
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (OLD.ttm_idtowmag=NEW.ttm_idtowmag) THEN
   deltaplusnew=deltaplusnew+deltaplusold;
   deltaminusnew=deltaminusnew+deltaminusold;
   deltaplusold=0;
   deltaminusold=0;
  END IF;
 END IF;

 IF ((deltaplusold<>0) OR (deltaminusold<>0)) THEN
  UPDATE tg_towmag SET ttm_bkorderplus=ttm_bkorderplus+deltaplusold,ttm_bkorderminus=ttm_bkorderminus+deltaminusold WHERE ttm_idtowmag=OLD.ttm_idtowmag;
 END IF;

 IF ((deltaplusnew<>0) OR (deltaminusnew<>0)) THEN
  UPDATE tg_towmag SET ttm_bkorderplus=ttm_bkorderplus+deltaplusnew,ttm_bkorderminus=ttm_bkorderminus+deltaminusnew WHERE ttm_idtowmag=NEW.ttm_idtowmag;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
