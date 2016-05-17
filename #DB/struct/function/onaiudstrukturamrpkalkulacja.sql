CREATE FUNCTION onaiudstrukturamrpkalkulacja() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 _ilosc_mat NUMERIC:=0;
 _th_optpartia NUMERIC:=1;
 _ttw_idmaterialu INT;
 
 _isInsert BOOL:=FALSE;
 _isUpdate BOOL:=FALSE;
BEGIN

 IF (TG_OP='INSERT') THEN -- Mam inserta, dodaje material
  IF ((NEW.sk_flaga&(1<<6))=(1<<6)) THEN -- Oczywiscie jesli to kalkulacja...
   IF (NEW.ttw_idmaterialu IS NOT NULL) THEN -- ... i mam material
_isInsert=TRUE;
   END IF;
   
   -- Updejtuje technologie
   UPDATE tr_technologie SET sk_idstruktury=NEW.sk_idstruktury WHERE th_idtechnologii=NEW.th_idtechnologii;
   
  END IF;
 END IF;
 
 IF (TG_OP='UPDATE') THEN -- Mam update, aktualizuje lub dodaje material
  IF ((NEW.sk_flaga&(1<<6))=(1<<6)) THEN -- Oczywiscie jesli to kalkulacja...
   IF (OLD.ttw_idmaterialu IS NULL AND NEW.ttw_idmaterialu IS NOT NULL) THEN -- Nie mialem materialu a mam: Robie inserta
_isInsert=TRUE;
   END IF;
   
   IF (OLD.ttw_idmaterialu IS NOT NULL AND NEW.ttw_idmaterialu IS NULL) THEN -- Mialem materialu a nie mam: Robie delete
    DELETE FROM tr_rrozchodu WHERE trr_flaga&(1<<6)=(1<<6) AND th_idtechnologii=NEW.th_idtechnologii;
   END IF;
  
   IF (OLD.ttw_idmaterialu IS NOT NULL AND NEW.ttw_idmaterialu IS NOT NULL) THEN -- Mialem materialu i dalej mam: Sprawdzam dalej
    IF (
    (NEW.ttw_idmaterialu<>OLD.ttw_idmaterialu) OR
        (NEW.sk_wymiar_x IS DISTINCT FROM OLD.sk_wymiar_x) OR
    (NEW.sk_wymiar_y IS DISTINCT FROM OLD.sk_wymiar_y) OR
    (NEW.sk_wymiar_z IS DISTINCT FROM OLD.sk_wymiar_z) OR    
    (NEW.sk_naddatek_x IS DISTINCT FROM OLD.sk_naddatek_x) OR
    (NEW.sk_naddatek_y IS DISTINCT FROM OLD.sk_naddatek_y) OR
    (NEW.sk_naddatek_z IS DISTINCT FROM OLD.sk_naddatek_z) OR
    (NEW.sk_narzut_procent IS DISTINCT FROM OLD.sk_narzut_procent)
   ) THEN -- zmienily sie interesujace mnie dane: Robie update
   _isUpdate=TRUE;
END IF;
   END IF;
   
  END IF;
 END IF;  

 IF (TG_OP='DELETE') THEN -- Mam delete, usuwam material
  IF ((OLD.sk_flaga&(1<<6))=(1<<6) AND COALESCE(OLD.th_idtechnologii,0)>0) THEN -- Oczywiscie jesli to kalkulacja...
   DELETE FROM tr_technoelem WHERE th_idtechnologii=OLD.th_idtechnologii;
   DELETE FROM tr_technologie WHERE th_idtechnologii=OLD.th_idtechnologii;
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  _ilosc_mat=getiloscmatplanuzlecenia(NEW.ttw_idmaterialu,1,NEW.sk_wymiar_x,NEW.sk_wymiar_y,NEW.sk_wymiar_z,NEW.sk_naddatek_x,NEW.sk_naddatek_y,NEW.sk_naddatek_z, NEW.sk_narzut_procent);
  _th_optpartia=(SELECT th_optpartia FROM tr_technologie WHERE th_idtechnologii=NEW.th_idtechnologii);
  
  IF (_isUpdate) THEN
   UPDATE tr_rrozchodu SET
   trr_iloscl=(_ilosc_mat*_th_optpartia),
   trr_ilosclalt=_ilosc_mat,
   ttw_idtowaru=NEW.ttw_idmaterialu  
   WHERE trr_flaga&(1<<6)=(1<<6) AND th_idtechnologii=NEW.th_idtechnologii;
  END IF;
  
  IF (_isInsert) THEN
   INSERT INTO tr_rrozchodu
   (ttw_idtowaru,th_idtechnologii,trr_iloscl,trr_iloscm,trr_flaga,trr_wplywmag,trr_ilosclalt,trr_cena)
   VALUES
   (NEW.ttw_idmaterialu,NEW.th_idtechnologii,(_ilosc_mat*_th_optpartia),1,(1<<6),-1,_ilosc_mat,1);
  END IF;
 END IF;
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
