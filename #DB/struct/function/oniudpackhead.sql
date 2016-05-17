CREATE FUNCTION oniudpackhead() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 
BEGIN

 IF (TG_OP = 'INSERT') THEN
  NEW.pk_idukladu=NEW.pk_idpaczki;
  IF (NEW.pk_idref>0) THEN
   PERFORM zwiekszPowiazaniePaczek(NEW.pk_idref);
   NEW.pk_idukladu=(SELECT pk_idukladu FROM tg_packhead WHERE pk_idpaczki=NEW.pk_idref);
  END IF;
 END IF;

 IF (TG_OP = 'UPDATE') THEN
  IF (NullZero(OLD.pk_idref)<>NullZero(NEW.pk_idref)) THEN
   PERFORM zwiekszPowiazaniePaczek(NEW.pk_idref);
   PERFORM zmniejszPowiazaniePaczek(OLD.pk_idref);
   NEW.pk_idukladu=NEW.pk_idpaczki;
   IF (NEW.pk_idref>0) THEN
    NEW.pk_idukladu=(SELECT pk_idukladu FROM tg_packhead WHERE pk_idpaczki=NEW.pk_idref);
   END IF;
  END IF;
  IF (NullZero(OLD.pk_idukladu)<>NullZero(NEW.pk_idukladu)) THEN
  ---przy zmianie id ukladu zmieniam go rowniez w dol swojej galezi
   UPDATE tg_packhead SET pk_idukladu=NEW.pk_idukladu WHERE pk_idref=NEW.pk_idpaczki;
  END IF;
 END IF;

 IF (TG_OP = 'DELETE') THEN  
  IF ((OLD.pk_flaga&2)=2) THEN
   --- nie moge usunac bo mam paczki zalezne
   RAISE EXCEPTION 'Nie mozna usuwac paczki nadrzednej';
  END IF;

  IF (OLD.pk_idref>0) THEN
   PERFORM zmniejszPowiazaniePaczek(OLD.pk_idref);
  END IF;
  RETURN OLD;
 END IF;

 RETURN NEW;
END;$$;
