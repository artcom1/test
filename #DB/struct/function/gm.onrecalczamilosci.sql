CREATE FUNCTION onrecalczamilosci() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 ----Dla operacji DELETE wychodzimy bez zmian - rekord z tg_zamilosci pojdzie kaskada
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 ---Sprawdz czy to nie rekord - kopia
 IF ((NEW.tel_flaga&4096)!=0) THEN
  IF (TG_OP='UPDATE') THEN
   IF (NEW.tel_iloscf IS DISTINCT FROM OLD.tel_iloscf) THEN
    PERFORM gm.updateZamIlosci(te,TRUE) FROM tg_realizacjapzam AS r JOIN tg_transelem AS te ON (te.tel_idelem=r.tel_idpzam AND r.rm_powod=4) WHERE r.tel_idelemsrc=NEW.tel_idelem AND r.rm_powod=4;
   END IF;
  END IF;
  --Tak - pomijaj zawsze
  RETURN NEW;
 END IF;
 
 ---Jesli ma nie byc rekordu w zamilosci - skasuj go
 IF ((NEW.tel_newflaga&(1<<19))=0) THEN
  DELETE FROM tg_zamilosci WHERE tel_idelem=NEW.tel_idelem;
  RETURN NEW;
 END IF;
 
 IF (TG_OP='INSERT') THEN
  PERFORM gm.updateZamIlosci(NEW,TRUE);
 ELSE
  ---Aktualizujemy ilosci jesli transelem jest w buforze lub pozycja nie jest zrodlem backorder'a
  PERFORM gm.updateZamIlosci(NEW,((OLD.tel_flaga&16)=0) OR ((NEW.tel_flaga&(1<<19))=0));
 END IF;
 
 
 RETURN NEW;
END;
$$;
