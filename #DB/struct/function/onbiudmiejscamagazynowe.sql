CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 pobraniefull bool:=false;
BEGIN
 
 IF (TG_OP='INSERT') THEN
  pobraniefull=true;
  NEW.mm_prorytet=(SELECT 1+max(mm_prorytet) FROM ts_miejscamagazynowe WHERE mm_magazyn=NEW.mm_magazyn);
  NEW.fm_idcentrali=(SELECT fm_idcentrali FROM tg_magazyny WHERE tg_magazyny.tmg_idmagazynu=NEW.mm_magazyn);
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NEW.mm_kod!=OLD.mm_kod) THEN
   pobraniefull=true;
  END IF;
  IF (NEW.mm_l!=(NEW.mm_r-1) ) THEN
   NEW.mm_prorytet=NULL;
  END IF;
 END IF;

 IF (TG_OP!='DELETE') THEN
  NEW.mm_isleaf=(NEW.mm_l+1 IS NOT DISTINCT FROM NEW.mm_r);
 END IF;  
 
 IF (pobraniefull) THEN
  IF (NEW.mm_parent IS NULL) THEN
   NEW.mm_fullnumer=NEW.mm_kod;
  ELSE 
   NEW.mm_fullnumer=splaszczMiejsceMagazynowe(NEW.mm_parent)||'-'||NEW.mm_kod;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
