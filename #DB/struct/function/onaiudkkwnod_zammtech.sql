CREATE FUNCTION onaiudkkwnod_zammtech() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 iloscZamiennikow INT:=0;
BEGIN
 
 IF (TG_OP='INSERT') THEN
 -- Przy insercie ustawiam flage na parencie jesli dodalem podrzedny
  IF (NEW.knr_idparent IS NOT NULL) THEN
   UPDATE tr_nodrec SET trr_flaga=trr_flaga|(1<<7) WHERE knr_idelemu=NEW.knr_idparent;
  END IF;
 END IF;
 
 IF (TG_OP='UPDATE') THEN
 -- Przy updacie i zmianie pewnych pol nadrzednego aktualizuje je na podrzednych
  IF (NEW.trr_flaga&(1<<7)=(1<<7)) THEN
   IF (NullZero(OLD.tmg_idmagazynu)<>NullZero(NEW.tmg_idmagazynu)) THEN
    UPDATE tr_nodrec SET 
	knr_lp=NEW.knr_lp, 
	kwe_idelemu=NEW.kwe_idelemu, 
	tmg_idmagazynu=NEW.tmg_idmagazynu, 
	ttm_idtowmag=gettowmag(ttw_idtowaru,NEW.tmg_idmagazynu,TRUE),
	trr_flaga=trr_flaga&(~((3<<0)|(1<<4)))|(NEW.trr_flaga&((3<<0)|(1<<4))) 
	WHERE knr_idparent=NEW.knr_idelemu;
   ELSE
    IF (
	    NullZero(OLD.kwe_idelemu)<>NullZero(NEW.kwe_idelemu) OR 
		(OLD.trr_flaga&((3<<0)|(1<<4)))<>(NEW.trr_flaga&((3<<0)|(1<<4))) OR 
	    OLD.knr_lp<>NEW.knr_lp
	   ) THEN
	 UPDATE tr_nodrec SET knr_lp=NEW.knr_lp, kwe_idelemu=NEW.kwe_idelemu, trr_flaga=trr_flaga&(~((3<<0)|(1<<4)))|(NEW.trr_flaga&((3<<0)|(1<<4))) WHERE knr_idparent=NEW.knr_idelemu;
	END IF;
   END IF;
  END IF;
 END IF;
 
 IF (TG_OP='DELETE') THEN  
 -- Przy delecie ustawiam flage na parencie jesli nie mam juz podrzednych
  iloscZamiennikow=(SELECT count(*) FROM tr_nodrec WHERE knr_idparent=OLD.knr_idparent AND knr_idelemu<>OLD.knr_idelemu);
  IF (iloscZamiennikow=0) THEN
   UPDATE tr_nodrec SET trr_flaga=trr_flaga&(~(1<<7)) WHERE knr_idelemu=OLD.knr_idparent;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END;
$$;
