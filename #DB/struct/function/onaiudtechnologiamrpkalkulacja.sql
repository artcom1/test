CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='UPDATE') THEN -- Mam update, aktualizuje strukture
  IF (NEW.th_rodzaj=4) THEN -- Oczywiscie jesli to kalkulacja...
   IF (
        (NEW.th_kod IS DISTINCT FROM OLD.th_kod) OR
        (NEW.th_nazwa IS DISTINCT FROM OLD.th_nazwa) OR
    (NEW.th_opis IS DISTINCT FROM OLD.th_opis) OR
    ((NEW.th_flaga&(1<<3))<>(OLD.th_flaga&(1<<3))) OR
    (NEW.ttw_idtowaru IS DISTINCT FROM OLD.ttw_idtowaru) OR    
    (NEW.fm_idcentrali IS DISTINCT FROM OLD.fm_idcentrali) OR
    (NEW.thg_idgrupy IS DISTINCT FROM OLD.thg_idgrupy) OR
    (NEW.p_idpraczatwierdz IS DISTINCT FROM OLD.p_idpraczatwierdz)
   ) THEN -- ... i zmienily sie interesujace nas dane
    UPDATE tr_strukturakonstrukcyjna SET 
 sk_kod=NEW.th_kod,
 sk_nazwa=NEW.th_nazwa,
 sk_opis=NEW.th_opis,
 sk_flaga=(CASE WHEN (NEW.th_flaga&(1<<3))=(1<<3) THEN sk_flaga|(1<<0) ELSE sk_flaga&(~(1<<0)) END),
 ttw_idtowaru=NEW.ttw_idtowaru,
 fm_idcentrali=NEW.fm_idcentrali,
 thg_idgrupy=NEW.thg_idgrupy,
 p_idpracownikazat=NEW.p_idpraczatwierdz,
 sk_dataakceptacji=(CASE WHEN ((NEW.th_flaga&(1<<3))=(1<<3) AND (NEW.th_flaga&(1<<3))<>(OLD.th_flaga&(1<<3))) THEN now() ELSE NULL END)
    WHERE th_idtechnologii=NEW.th_idtechnologii;
   END IF;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN -- Mam deleta, usuwam strukture
  IF (OLD.th_rodzaj=4 AND COALESCE(OLD.sk_idstruktury,0)>0) THEN -- Oczywiscie jesli to kalkulacja...
   DELETE FROM tr_strukturakonstrukcyjna WHERE sk_idstruktury=OLD.sk_idstruktury;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
