CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE 
 vold NUMERIC:=0;
 vnew NUMERIC:=0;
BEGIN
 
 IF (TG_OP<>'INSERT') THEN
  IF (isForAkcjaM(OLD.a_idakcji,OLD.tel_skojlog,OLD.tel_flaga,OLD.tel_sprzedaz)=TRUE) THEN
   vold=-OLD.tel_iloscf;
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  IF (isForAkcjaM(NEW.a_idakcji,NEW.tel_skojlog,NEW.tel_flaga,NEW.tel_sprzedaz)=TRUE) THEN
   vnew=NEW.tel_iloscf;
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (OLD.a_idakcji IS NOT DISTINCT FROM NEW.a_idakcji AND OLD.tel_idklienta IS NOT DISTINCT FROM NEW.tel_idklienta) THEN
   vnew=vnew+vold;
   vold=0;
  END IF;
 END IF;

 IF (vold<>0) THEN
  PERFORM updateTowarOnAkcja(OLD.a_idakcji,OLD.ttw_idtowaru,OLD.tel_idklienta,vold);
 END IF;

 IF (vnew<>0) THEN
  PERFORM updateTowarOnAkcja(NEW.a_idakcji,NEW.ttw_idtowaru,NEW.tel_idklienta,vnew);
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
