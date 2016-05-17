CREATE FUNCTION oniudpowiazaniepaczek() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN

 IF (TG_OP = 'INSERT') THEN
  IF (NEW.pp_ile>0) THEN
   UPDATE tg_packhead SET pk_flaga=pk_flaga|2 WHERE pk_idpaczki=NEW.pk_idpaczki ;
  END IF;
 END IF;

 IF (TG_OP = 'UPDATE') THEN

  IF (NEW.pk_idpaczki<>OLD.pk_idpaczki) THEN
    RAISE EXCEPTION 'Nie mozna w ten sposob zmieniac paczki';
  END IF;

  IF (NEW.pp_ile<=0 AND OLD.pp_ile>0) THEN
   UPDATE tg_packhead SET pk_flaga=pk_flaga&(~2) WHERE pk_idpaczki=NEW.pk_idpaczki ;
  END IF;

  IF (NEW.pp_ile>0 AND OLD.pp_ile<=0) THEN
   UPDATE tg_packhead SET pk_flaga=pk_flaga|2 WHERE pk_idpaczki=NEW.pk_idpaczki ;
  END IF;

 END IF;

 IF (TG_OP = 'DELETE') THEN
  UPDATE tg_packhead SET pk_flaga=pk_flaga&(~2) WHERE pk_idpaczki=OLD.pk_idpaczki ;
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END;$$;
