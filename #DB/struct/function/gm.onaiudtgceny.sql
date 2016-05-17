CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='UPDATE') THEN
  IF (NEW.* IS NOT DISTINCT FROM OLD.*) THEN
   RETURN NEW;
  END IF;
 END IF;

 IF (vendo.gettparami('XREFSYNCCENY',0)=0) THEN
 
  PERFORM vendo.settparami('XREFSYNCCENY',vendo.gettparami('XREFSYNCCENY',0)+1);
 
  IF (TG_OP='DELETE') THEN
   PERFORM gm.syncCenyTow(a.ttw_idxref,a.ttw_idtowaru) FROM tg_towary AS a WHERE a.ttw_idxref=OLD.ttw_idtowaru AND a.ttw_idxref IS NOT NULL AND (a.ttw_newflaga&(1<<24))!=0;
  ELSE  
   PERFORM gm.syncCenyTow(a.ttw_idxref,a.ttw_idtowaru) FROM tg_towary AS a WHERE a.ttw_idxref=NEW.ttw_idtowaru AND a.ttw_idxref IS NOT NULL AND (a.ttw_newflaga&(1<<24))!=0;
  END IF;

  PERFORM vendo.settparami('XREFSYNCCENY',vendo.gettparami('XREFSYNCCENY',0)-1);
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END
$$;
