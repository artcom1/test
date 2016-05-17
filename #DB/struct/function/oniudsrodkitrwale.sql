CREATE FUNCTION oniudsrodkitrwale() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 dnetto NUMERIC:=0;
 dnettokoszt NUMERIC:=0;
BEGIN
  IF (TG_OP <> 'INSERT') THEN
    dnetto=dnetto-OLD.str_wartprzen;
    dnettokoszt=dnettokoszt-OLD.str_wartprzenkoszt;
  END IF;
  
  IF (TG_OP <> 'DELETE') THEN
    dnetto=dnetto+NEW.str_wartprzen;
    dnettokoszt=dnettokoszt+NEW.str_wartprzenkoszt;
    NEW.str_wartumoz=NEW.str_wartumoz+dnetto;
    NEW.str_wartumozkoszt=NEW.str_wartumozkoszt+dnettokoszt;
  END IF;

  IF (TG_OP <> 'DELETE') THEN
   NEW.str_wartbiez=NEW.str_wartpocz+NEW.str_wartosczdarzen-NEW.str_wartumoz;
   NEW.str_wartbiezkoszt=NEW.str_wartpoczkoszt+NEW.str_wartosczdarzenkoszt-NEW.str_wartumozkoszt;
  END IF;

  IF (TG_OP = 'DELETE') THEN
    RETURN OLD;
  END IF;
  RETURN NEW;
END;
 $$;
