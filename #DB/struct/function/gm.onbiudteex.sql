CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='DELETE') THEN
  PERFORM vendo.setTParamI('TEXDELETED_'||OLD.tex_idelem::text,1);
 END IF;

 IF (TG_OP='INSERT') THEN
  IF (NEW.prt_idpartii IS NULL) THEN
   NEW.prt_idpartii=gm.getIDNULLPartii((SELECT ttw_idtowaru FROM tg_towmag WHERE ttm_idtowmag=NEW.ttm_idtowmag),TRUE,(CASE WHEN NEW.tex_sprzedaz<0 THEN -2 ELSE 1 END));
  END IF;
  
  NEW.tex_iloscf=NEW.tex_iloscf-NEW.tex_iloscfzreal;  
 END IF;
 
 IF (TG_OP='UPDATE') THEN
  NEW.tex_iloscf=NEW.tex_iloscf-NEW.tex_iloscfzreal+OLD.tex_iloscfzreal;  
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;

 RETURN NEW;
END;
$$;
