CREATE FUNCTION oniudzlecenie_podzlecenia() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 ile INT;
BEGIN
  
 IF (TG_OP='INSERT' OR TG_OP='UPDATE') THEN -- Mam zlec nadrzedne wiec ustawiam na nim flage
  IF (NEW.zl_idref IS NOT NULL) THEN
   UPDATE tg_zlecenia SET zl_flaga=(zl_flaga|4) WHERE zl_idzlecenia=NEW.zl_idref AND (zl_flaga&4)=0;  
  END IF;
 END IF;
   
 IF (TG_OP='DELETE') THEN -- Mialem zlec nadrzedne wiec moze ustawiam na nim flage
  IF (OLD.zl_idref IS NOT NULL) THEN
   ile=(SELECT count(*) FROM tg_zlecenia WHERE zl_idref=OLD.zl_idref AND zl_idzlecenia!=OLD.zl_idzlecenia);
   IF (ile=0) THEN
    UPDATE tg_zlecenia SET zl_flaga=zl_flaga&(~4) WHERE zl_idzlecenia=OLD.zl_idref AND (zl_flaga&4)=4;
   END IF;
  END IF;
 END IF;
 
 IF (TG_OP='UPDATE') THEN
  IF (OLD.zl_idref<>NEW.zl_idref) THEN
   ile=(SELECT count(*) FROM tg_zlecenia WHERE zl_idref=OLD.zl_idref AND zl_idzlecenia!=OLD.zl_idzlecenia);
   IF (ile=0) THEN
    UPDATE tg_zlecenia SET zl_flaga=zl_flaga&(~4) WHERE zl_idzlecenia=OLD.zl_idref AND (zl_flaga&4)=4;
   END IF;
  END IF;
 END IF;
 
 IF (TG_OP='UPDATE') THEN
  IF (NEW.zl_rodzajnum=2) THEN
   IF ( 
	   (OLD.zl_nrzlecenia<>NEW.zl_nrzlecenia) OR
	   (OLD.zl_seria<>NEW.zl_seria) OR
	   (OLD.zl_rok<>NEW.zl_rok) OR
	   (OLD.zl_prefixparent<>NEW.zl_prefixparent) OR
       (OLD.zl_prefix<>NEW.zl_prefix) OR 
	   (OLD.zl_rodzajnum<>NEW.zl_rodzajnum)
	  ) THEN
	  UPDATE tg_zlecenia SET zl_nrzlecenia=NEW.zl_nrzlecenia, zl_seria=NEW.zl_seria, zl_rok=NEW.zl_rok, zl_rodzajnum=NEW.zl_rodzajnum, zl_prefixparent=(CASE WHEN COALESCE(NEW.zl_prefixparent,'')='' THEN COALESCE(NEW.zl_prefix,'') ELSE NEW.zl_prefixparent||'/'||COALESCE(NEW.zl_prefix,'') END) WHERE zl_idref=NEW.zl_idzlecenia;
   END IF;
  ELSE
   IF ((OLD.zl_prefix<>NEW.zl_prefix) OR (OLD.zl_prefixparent<>NEW.zl_prefixparent) OR (OLD.zl_rodzajnum<>NEW.zl_rodzajnum)) THEN
    UPDATE tg_zlecenia SET zl_rodzajnum=NEW.zl_rodzajnum, zl_prefixparent=(CASE WHEN COALESCE(NEW.zl_prefixparent,'')='' THEN COALESCE(NEW.zl_prefix,'') ELSE NEW.zl_prefixparent||'/'||COALESCE(NEW.zl_prefix,'') END) WHERE zl_idref=NEW.zl_idzlecenia;
   END IF;
  END IF;
 END IF;
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END;
$$;
