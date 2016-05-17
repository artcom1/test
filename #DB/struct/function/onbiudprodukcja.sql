CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 zmiana bool:=false;
 receptura RECORD;
 _tsk_idreceptura INT:=null;
BEGIN
 
 IF (TG_OP='INSERT') THEN
  IF (NEW.tsk_flaga&3=2 AND NEW.tsk_flaga&64=64) THEN
   SELECT ttw_idtowaru, fm_idindextab INTO receptura FROM tg_produkcja AS wyr JOIN tb_firma AS f ON (wyr.fm_idcentrali=f.fm_index) WHERE tsk_idreceptury=NEW.tsk_idskladnika AND tsk_flaga&3=1;
   zmiana=true;
   _tsk_idreceptura=NEW.tsk_idskladnika;
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NEW.tsk_flaga&3=2 AND  (OLD.tsk_flaga&64)<>(NEW.tsk_flaga&64)) THEN
   SELECT ttw_idtowaru, fm_idindextab INTO receptura FROM tg_produkcja AS wyr JOIN tb_firma AS f ON (wyr.fm_idcentrali=f.fm_index) WHERE tsk_idreceptury=OLD.tsk_idskladnika AND tsk_flaga&3=1;
   zmiana=true;
   IF (NEW.tsk_flaga&64=64) THEN
    _tsk_idreceptura=NEW.tsk_idskladnika;
   ELSE
    _tsk_idreceptura=null;
   END IF;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  IF (OLD.tsk_flaga&3=2 AND OLD.tsk_flaga&64=64) THEN
   SELECT ttw_idtowaru, fm_idindextab INTO receptura FROM tg_produkcja AS wyr JOIN tb_firma AS f ON (wyr.fm_idcentrali=f.fm_index) WHERE tsk_idreceptury=OLD.tsk_idskladnika AND tsk_flaga&3=1;
   zmiana=true;
   _tsk_idreceptura=null;
  END IF;
 END IF;

 IF (zmiana) THEN
  UPDATE tg_towary SET ttw_domyslnareceptura[receptura.fm_idindextab]=_tsk_idreceptura WHERE ttw_idtowaru=receptura.ttw_idtowaru;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
