CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 tmp   NUMERIC;
 delta NUMERIC:=0;
BEGIN

 IF (TG_OP='DELETE') THEN
  PERFORM gm.updateStanPartii(OLD.prt_idpartii,OLD.ptm_stanmag,0,OLD.ptm_pzetscount,0);
 END IF;

 IF (TG_OP='UPDATE') THEN
  PERFORM gm.updateStanPartii(NEW.prt_idpartii,OLD.ptm_stanmag,NEW.ptm_stanmag,OLD.ptm_pzetscount,NEW.ptm_pzetscount);
 END IF;

 IF (TG_OP='INSERT') THEN
  PERFORM gm.updateStanPartii(NEW.prt_idpartii,0,NEW.ptm_stanmag,0,NEW.ptm_pzetscount);
 END IF;

 IF (TG_OP<>'DELETE') THEN
  IF (COALESCE(vendo.getTParam('BLOCKREZSEARCH'),'0')='0') THEN
   IF (NEW.ptm_rezerwacje+NEW.ptm_rezerwacjel>NEW.ptm_stanmag) THEN
    tmp=NEW.ptm_rezerwacje+NEW.ptm_rezerwacjel-NEW.ptm_stanmag;
    IF (tmp>NEW.ptm_rezerwacjel) THEN
     ---RAISE EXCEPTION 'Blad rezerwacji TowMag';
    END IF;
    tmp=min(tmp,NEW.ptm_rezerwacjel);
    delta=tmp;
    PERFORM gm.zmniejszRezerwacjeLekkieTowMag(NEW.ttm_idtowmag,NEW.prt_idpartii,tmp);
   END IF;
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  IF (NEW.ptm_stanmag-NEW.ptm_rezerwacje-NEW.ptm_rezerwacjel+delta<0) THEN
   IF (gm.istriggerfunctionactive('CHECKRLP')=TRUE) THEN
    RAISE EXCEPTION 'Blad RLP %(%-%-%)',NEW.ptm_id,NEW.ptm_stanmag,NEW.ptm_rezerwacje,NEW.ptm_rezerwacjel;
   ELSE
    RAISE NOTICE 'Blad RLP %(%-%-%)',NEW.ptm_id,NEW.ptm_stanmag,NEW.ptm_rezerwacje,NEW.ptm_rezerwacjel;
   END IF;
  END IF;
 END IF;
 
 IF (TG_OP='UPDATE') THEN
  IF (NEW.ptm_stanmag<OLD.ptm_stanmag) OR (NEW.ptm_rezerwacje<OLD.ptm_rezerwacje) OR (NEW.ptm_rezerwacjel<OLD.ptm_rezerwacjel) THEN
   IF (gm.kj_iszmianaallowed(NEW.prt_idpartii,NEW.ptm_inkj)=FALSE) THEN
    RAISE EXCEPTION '52|%|Niedozwolony rozchod na partii z KJ',NEW.prt_idpartii;
   END IF;
  END IF;
 END IF;

 ----RAISE NOTICE 'RLP %(%-%-%)',NEW.ptm_id,NEW.ptm_stanmag,NEW.ptm_rezerwacje,NEW.ptm_rezerwacjel;
 IF (TG_OP='UPDATE') THEN
  IF (NEW.ptm_idparent IS DISTINCT FROM OLD.ptm_idparent) THEN
   RAISE EXCEPTION 'TG_PARTIETM: Rodzica mozna ustawic tylko w operacji INSERT';
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
