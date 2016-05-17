CREATE FUNCTION onaiudpartetm_rozm() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 IF (TG_OP!='DELETE') THEN
  IF (NEW.ptm_idparent IS NOT NULL) THEN
   IF (TG_OP='INSERT') THEN
    PERFORM gm.updateptm(prt_idpartii,ttm_idtowmag,NEW.ptm_stanmag,NEW.ptm_rezerwacje,NEW.ptm_rezerwacjel-NEW.ptm_wtymrezlnull,FALSE,NEW.ptm_stanmagpotw,NEW.ptm_pzetscount) FROM tg_partietm WHERE ptm_id=NEW.ptm_idparent;
	PERFORM gm.updateptm(prt_idpartii,ttm_idtowmag,0,0,NEW.ptm_wtymrezlnull,TRUE,0,0) FROM tg_partietm WHERE ptm_id=NEW.ptm_idparent;
   END IF;
   IF (TG_OP='UPDATE') THEN
    PERFORM gm.updateptm(prt_idpartii,ttm_idtowmag,
	                     NEW.ptm_stanmag-OLD.ptm_stanmag,NEW.ptm_rezerwacje-OLD.ptm_rezerwacje,
						 (NEW.ptm_rezerwacjel-NEW.ptm_wtymrezlnull)-(OLD.ptm_rezerwacjel-OLD.ptm_wtymrezlnull),
						 FALSE,NEW.ptm_stanmagpotw-OLD.ptm_stanmagpotw,NEW.ptm_pzetscount-OLD.ptm_pzetscount) FROM tg_partietm WHERE ptm_id=OLD.ptm_idparent;
	PERFORM gm.updateptm(prt_idpartii,ttm_idtowmag,0,0,NEW.ptm_wtymrezlnull-OLD.ptm_wtymrezlnull,TRUE,0,0) FROM tg_partietm WHERE ptm_id=OLD.ptm_idparent;
   END IF;
  END IF;
 ELSE
  IF (OLD.ptm_idparent IS NOT NULL) THEN
    PERFORM gm.updateptm(prt_idpartii,ttm_idtowmag,
	                    -OLD.ptm_stanmag,-OLD.ptm_rezerwacje,
	  				    -(OLD.ptm_rezerwacjel-OLD.ptm_wtymrezlnull),
	 					FALSE,-OLD.ptm_stanmagpotw,-OLD.ptm_pzetscount) FROM tg_partietm WHERE ptm_id=OLD.ptm_idparent;
	PERFORM gm.updateptm(prt_idpartii,ttm_idtowmag,0,0,-OLD.ptm_wtymrezlnull,TRUE,0,0) FROM tg_partietm WHERE ptm_id=OLD.ptm_idparent;
  END IF;
 END IF;
 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
