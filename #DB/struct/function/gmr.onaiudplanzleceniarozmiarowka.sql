CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='INSERT') THEN
  IF (NEW.pz_rmp_idsposobu IS NOT NULL) THEN
   PERFORM gmr.initplanzleceniarozmelems(NEW.pz_idplanu,NEW.pz_rmp_idsposobu,NEW.ttw_idtowaru,NEW.pz_ilosckartonow,NEW.tel_idsrcelem);
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NEW.pz_rmp_idsposobu IS NOT NULL) OR (OLD.pz_rmp_idsposobu IS NOT NULL) THEN
   IF (NEW.pz_idplanu IS DISTINCT FROM OLD.pz_idplanu OR 
       NEW.pz_rmp_idsposobu IS DISTINCT FROM OLD.pz_rmp_idsposobu OR
	   NEW.ttw_idtowaru IS DISTINCT FROM OLD.ttw_idtowaru OR
	   NEW.pz_ilosckartonow IS DISTINCT FROM OLD.pz_ilosckartonow OR
	   NEW.tel_idsrcelem IS DISTINCT FROM OLD.tel_idsrcelem)
   THEN
    PERFORM gmr.initplanzleceniarozmelems(NEW.pz_idplanu,NEW.pz_rmp_idsposobu,NEW.ttw_idtowaru,NEW.pz_ilosckartonow,NEW.tel_idsrcelem);
   END IF;	

   IF (NEW.pz_ilosczreal IS DISTINCT FROM OLD.pz_ilosczreal OR 
       NEW.pz_ilosczrealclosed IS DISTINCT FROM OLD.pz_ilosczrealclosed)      
   THEN
    UPDATE gmr.tg_planzleceniarozmelems SET
	pzw_iloscopzreal = pzw_iloscop*(CASE WHEN NEW.pz_iloscroz<>0 THEN (NEW.pz_ilosczreal/NEW.pz_iloscroz) ELSE 0 END),
	pzw_iloscopzrealclosed = pzw_iloscop*(CASE WHEN NEW.pz_iloscroz<>0 THEN (NEW.pz_ilosczrealclosed/NEW.pz_iloscroz) ELSE 0 END)
	WHERE pz_idplanu = NEW.pz_idplanu;
   END IF;   
  
  END IF;
 END IF;
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 RETURN NEW;
END
$$;
