CREATE FUNCTION oniudbilety() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 
BEGIN

 IF (TG_OP = 'INSERT') THEN

 END IF;

 
 IF (TG_OP = 'UPDATE') THEN 
  IF (NEW.tel_idelem>0 AND OLD.tel_idelem>0) THEN
  ---jesli zafakturowany to nie mozna zmieniac ilosci 
   IF (NEW.bl_ilosc<>OLD.bl_ilosc) THEN
    RAISE EXCEPTION 'Nie mo??na zmienia?? ilo??ci na zafakturowanym bilecie!';
   END IF;
   IF (NEW.tel_idelem<>OLD.tel_idelem) THEN
    RAISE EXCEPTION 'Nie mo??na w ten spos??b zmieniac dokumentu handlowego!';
   END IF;
  END IF;
  IF (NEW.tel_idelem>0 AND OLD.tel_idelem = NULL) THEN
   ---uakualniamy ilosci przy dodawaniu do biletu zafakturowania
   UPDATE tg_transelem SET tel_ilosc=tel_ilosc+NEW.bl_ilosc WHERE tel_idelem=NEW.tel_idelem;
  END IF;

  IF (NEW.tel_idelem=NULL AND OLD.tel_idelem >0 ) THEN
   ---uakualniamy ilosci przy usuwaniu z biletu zafakturowania
   UPDATE tg_transelem SET tel_ilosc=tel_ilosc-OLD.bl_ilosc WHERE tel_idelem=OLD.tel_idelem;
  END IF;
 END IF;

 IF (TG_OP = 'DELETE') THEN
  IF (OLD.tel_idelem>0) THEN
    RAISE EXCEPTION 'Nie mo??na usuna?? zafakturowanego biletu!';
  END IF;
  RETURN OLD;
 END IF;

 RETURN NEW;
END;
$$;
