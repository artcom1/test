CREATE FUNCTION onaiutechnorrozchodu_wymiary() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 _przeliczacIlosc   BOOLEAN:=FALSE;
 _przeliczacWymiary BOOLEAN:=FALSE;
 rec                RECORD;
BEGIN
   
 IF (TG_OP='INSERT') THEN 
  _przeliczacIlosc=(NEW.trr_iloscl>0 AND NEW.trr_iloscprzel=0);
  _przeliczacWymiary=(NEW.trr_iloscl>0 AND NEW.trr_wymiar_x=0 AND NEW.trr_wymiar_y=0 AND NEW.trr_wymiar_z=0);
 END IF;
  
 IF (TG_OP='UPDATE') THEN 
  _przeliczacIlosc=(NEW.trr_iloscl<>OLD.trr_iloscl AND NEW.trr_iloscprzel=OLD.trr_iloscprzel);
  _przeliczacWymiary=(NEW.trr_iloscl<>OLD.trr_iloscl AND NEW.trr_wymiar_x=OLD.trr_wymiar_x AND NEW.trr_wymiar_y=OLD.trr_wymiar_y AND NEW.trr_wymiar_z=OLD.trr_wymiar_z AND NEW.trr_narzut_procent=OLD.trr_narzut_procent);  
  
  IF (NEW.trr_ilosckrotnosc<>OLD.trr_ilosckrotnosc) THEN
   _przeliczacIlosc=FALSE;
   _przeliczacWymiary=FALSE;
  END IF;
 END IF;  
  
 IF (_przeliczacIlosc OR _przeliczacWymiary) THEN
  rec=getPrzeliczoneWymiaryIlosc(NEW.ttw_idtowaru,NEW.trr_iloscl::MPQ,_przeliczacIlosc);
  IF (rec IS NOT NULL) THEN
   -- Przeliczona ilosc
   IF (_przeliczacIlosc) THEN
    NEW.trr_iloscprzel=rec.iloscprzel;
   END IF;
   -- Przeliczone wymiary
   IF (_przeliczacWymiary) THEN
    NEW.trr_narzut_procent=rec.narzut_procent;
    NEW.trr_wymiar_x=rec.wymiar_x;
    NEW.trr_wymiar_y=rec.wymiar_y;
    NEW.trr_wymiar_z=rec.wymiar_z; 
   END IF;   
  END IF; -- IF (rec IS NOT NULL) THEN
 END IF; -- IF (_przeliczacIlosc OR _przeliczacWymiary) THEN
 
 RETURN NEW;
END;
$$;
