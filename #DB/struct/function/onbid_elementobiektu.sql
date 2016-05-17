CREATE FUNCTION onbid_elementobiektu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
 ile INT:=0;
BEGIN

 IF (TG_OP='INSERT') THEN
  IF (NEW.ero_idelementu>0) THEN 
   ile=(SELECT count(*) FROM tg_elementobiektu WHERE ob_idobiektu=NEW.ob_idobiektu AND ero_idelementu=NEW.ero_idelementu);
  
   IF (ile=0) THEN
    --- element jednoczesnie pierwotny i aktualny
    NEW.eo_flaga=NEW.eo_flaga|((1<<1)|(1<<2));
   ELSE
    --- sa juz jakies elementy wiec dodaje na koniec lub poczatek
    --- Ustawiam jako aktualny
    IF (NEW.eo_idelementuprev IS NOT NULL AND NEW.eo_idelementuprev>0) THEN
     UPDATE tg_elementobiektu SET eo_flaga=(eo_flaga&(~(1<<1))) WHERE eo_idelementu=NEW.eo_idelementuprev AND ob_idobiektu=NEW.ob_idobiektu AND ero_idelementu=NEW.ero_idelementu;
     NEW.eo_flaga=NEW.eo_flaga|(1<<1);
    END IF;
 
    --- Ustawiam jako pierwotny
    IF (NEW.eo_idelementuprev IS NULL AND NEW.ero_idelementu>0) THEN
    --- Update przeniesiony do triggera after
    --- UPDATE tg_elementobiektu SET eo_flaga=(eo_flaga&(~(1<<2))) WHERE ob_idobiektu=NEW.ob_idobiektu AND ero_idelementu=NEW.ero_idelementu;
     NEW.eo_flaga=NEW.eo_flaga|(1<<2);
    END IF;   
   END IF; 
  END IF;
 END IF;
 
 IF (TG_OP='DELETE') THEN
  IF (OLD.ero_idelementu>0) THEN 
   ile=(SELECT count(*) FROM tg_elementobiektu WHERE ob_idobiektu=OLD.ob_idobiektu AND ero_idelementu=OLD.ero_idelementu);
 
   IF (ile>0) THEN
    --- Sa jakies inne elementy musze podzialac
    --- Czy bylem aktualnym   
    IF ((OLD.eo_flaga&(1<<1))=(1<<1)) THEN
     UPDATE tg_elementobiektu SET eo_flaga=(eo_flaga|(1<<1)) WHERE eo_idelementu=OLD.eo_idelementuprev AND ob_idobiektu=OLD.ob_idobiektu AND ero_idelementu=OLD.ero_idelementu;
    END IF;   
    --- Czy bylem pierwotnym
    IF ((OLD.eo_flaga&(1<<2))=(1<<2)) THEN
     UPDATE tg_elementobiektu SET eo_flaga=(eo_flaga|(1<<2)), eo_idelementuprev=NULL WHERE eo_idelementuprev=OLD.eo_idelementu AND ob_idobiektu=OLD.ob_idobiektu AND ero_idelementu=OLD.ero_idelementu;
    END IF;   
   END IF; 
  END IF;
 END IF;
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
