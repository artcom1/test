CREATE FUNCTION onaiudtechnorrozchodu_zammtech() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 iloscZamiennikow INT:=0;
BEGIN
 
 IF (TG_OP='INSERT') THEN
 -- Przy insercie ustawiam flage na parencie jesli dodalem podrzedny
  IF (NEW.trr_idparent IS NOT NULL) THEN
   UPDATE tr_rrozchodu SET trr_flaga=trr_flaga|(1<<7) WHERE trr_idelemu=NEW.trr_idparent;
  END IF;
 END IF;
 
 IF (TG_OP='UPDATE') THEN
 -- Przy updacie i zmianie pewnych pol nadrzednego aktualizuje je na podrzednych
  IF (
      (NEW.trr_flaga&(1<<7))=(1<<7) AND 
      (NullZero(OLD.the_idelem)<>NullZero(NEW.the_idelem) OR NullZero(OLD.tmg_idmagazynu)<>NullZero(NEW.tmg_idmagazynu) OR (OLD.trr_flaga&((3<<0)|(1<<4)))<>(NEW.trr_flaga&((3<<0)|(1<<4))))
     ) THEN
   UPDATE tr_rrozchodu SET the_idelem=NEW.the_idelem, tmg_idmagazynu=NEW.tmg_idmagazynu, trr_flaga=trr_flaga&(~((3<<0)|(1<<4)))|(NEW.trr_flaga&((3<<0)|(1<<4))) WHERE trr_idparent=NEW.trr_idelemu;
  END IF;  
 END IF;
 
 IF (TG_OP='DELETE') THEN  
 -- Przy delecie ustawiam flage na parencie jesli nie mam juz podrzednych
  IF (OLD.trr_idparent IS NOT NULL) THEN   
   iloscZamiennikow=(SELECT count(*) FROM tr_rrozchodu WHERE trr_idparent=OLD.trr_idparent AND trr_idelemu<>OLD.trr_idelemu);
   IF (iloscZamiennikow=0) THEN
    UPDATE tr_rrozchodu SET trr_flaga=trr_flaga&(~(1<<7)) WHERE trr_idelemu=OLD.trr_idparent;
   END IF;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END;
$$;
