CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 _przeliczacIlosc   BOOLEAN:=FALSE;
 _przeliczacWymiary BOOLEAN:=FALSE;
 rec                RECORD;
BEGIN

 IF (TG_OP='INSERT') THEN
  _przeliczacIlosc=(NEW.knr_licznik>0 AND NEW.knr_iloscprzel=0);
  _przeliczacWymiary=(NEW.knr_licznik>0 AND NEW.knr_wymiar_x=0 AND NEW.knr_wymiar_y=0 AND NEW.knr_wymiar_z=0);
 END IF;

 IF (TG_OP='UPDATE') THEN
  _przeliczacIlosc=(NEW.knr_licznik<>OLD.knr_licznik AND NEW.knr_iloscprzel=OLD.knr_iloscprzel);
  _przeliczacWymiary=(NEW.knr_licznik<>OLD.knr_licznik AND NEW.knr_wymiar_x=OLD.knr_wymiar_x AND NEW.knr_wymiar_y=OLD.knr_wymiar_y AND NEW.knr_wymiar_z=OLD.knr_wymiar_z AND NEW.knr_narzut_procent=OLD.knr_narzut_procent);
  
  IF (NEW.knr_ilosckrotnosc<>OLD.knr_ilosckrotnosc) THEN
   _przeliczacIlosc=FALSE;
   _przeliczacWymiary=FALSE;
  END IF;
 END IF;

 IF (_przeliczacIlosc OR _przeliczacWymiary) THEN
  rec=getPrzeliczoneWymiaryIlosc(NEW.ttw_idtowaru,NEW.knr_licznik::MPQ,_przeliczacIlosc);
  IF (rec IS NOT NULL) THEN
   -- Przeliczona ilosc
   IF (_przeliczacIlosc) THEN
    NEW.knr_iloscprzel=rec.iloscprzel;
   END IF;
   -- Przeliczone wymiary
   IF (_przeliczacWymiary) THEN
    NEW.knr_narzut_procent=rec.narzut_procent;
    NEW.knr_wymiar_x=rec.wymiar_x;
    NEW.knr_wymiar_y=rec.wymiar_y;
    NEW.knr_wymiar_z=rec.wymiar_z;
   END IF;
  END IF; -- IF (rec IS NOT NULL) THEN
 END IF; -- IF (_przeliczacIlosc OR _przeliczacWymiary) THEN
 
 RETURN NEW;
END;
$$;
