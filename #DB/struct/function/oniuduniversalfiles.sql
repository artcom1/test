CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 _ufl_ownertype INT;
 ilePlikow INT;
 _idzdarzenia INT;
 _idsprawy INT;
BEGIN

 ----------------------------------------------------------------------------
 --- Aktualizacja flag na wlascicielach
 ----------------------------------------------------------------------------
  
 IF (TG_OP='DELETE') THEN
_ufl_ownertype=OLD.ufl_ownertype;
 ELSE
_ufl_ownertype=NEW.ufl_ownertype;
 END IF;
 
 ----------------------------------------------------------------------------
 --- Transelemy
 ----------------------------------------------------------------------------
 IF (_ufl_ownertype=17) THEN
   IF (TG_OP='DELETE') THEN
    ilePlikow=(SELECT COUNT(*) FROM tb_universalfiles WHERE ufl_ownerid=OLD.ufl_ownerid AND ufl_ownertype=17);
IF (ilePlikow=1) THEN
 UPDATE tg_transelem SET tel_newflaga=tel_newflaga&(~(1<<30)) WHERE tel_idelem=OLD.ufl_ownerid; 
END IF;
   ELSE
UPDATE tg_transelem SET tel_newflaga=tel_newflaga|(1<<30) WHERE tel_idelem=NEW.ufl_ownerid;
   END IF; 
 END IF;
 
 ----------------------------------------------------------------------------
 --- Zdarzenia
 ----------------------------------------------------------------------------
 IF (_ufl_ownertype=206) THEN
  IF (TG_OP='DELETE') THEN
   _idzdarzenia=OLD.ufl_ownerid;
  ELSE
   _idzdarzenia=NEW.ufl_ownerid;
  END IF;
 
 _idsprawy=(SELECT (CASE WHEN zdarzenie_isticketheader(zd.zd_rodzaj)=TRUE THEN zd.zd_idzdarzenia ELSE par.zd_idzdarzenia END) FROM tb_zdarzenia AS zd LEFT JOIN tb_zdarzenia AS par ON (zd.zd_idparent=par.zd_idzdarzenia AND zdarzenie_isticketheader(par.zd_rodzaj)) WHERE zd.zd_idzdarzenia=_idzdarzenia);
  
  IF (TG_OP='DELETE') THEN
   ilePlikow=(SELECT COUNT(*) FROM tb_universalfiles WHERE (ufl_ownerid=_idzdarzenia OR (_idsprawy IS NOT NULL AND ufl_ownerid=_idsprawy)) AND ufl_ownertype=206);
   IF (ilePlikow<=1) THEN
    UPDATE tb_zdarzenia SET zd_flaga=zd_flaga&(~(1<<18)) WHERE zd_idzdarzenia=_idzdarzenia OR (_idsprawy IS NOT NULL AND zd_idparent=_idsprawy); 
   END IF;
  ELSE
    UPDATE tb_zdarzenia SET zd_flaga=zd_flaga|(1<<18) WHERE zd_idzdarzenia=_idzdarzenia OR (_idsprawy IS NOT NULL AND zd_idparent=_idsprawy);
  END IF; 
 END IF;
 
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
 
END;
$$;
