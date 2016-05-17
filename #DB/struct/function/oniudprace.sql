CREATE FUNCTION oniudprace() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN  
  IF (TG_OP='DELETE' OR TG_OP='UPDATE') THEN
   IF (OLD.zl_idzlecenia>0) THEN
   ---wycofujemy uaktualnienie dla starego zlecenia podpietego do pracy
    UPDATE tg_zlecenia SET zl_robocizna=zl_robocizna-NullZero(OLD.pr_koszt) WHERE zl_idzlecenia=OLD.zl_idzlecenia;
   END IF;
  END IF;
  IF (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
   IF (NEW.zl_idzlecenia>0) THEN
   ---dodajemy uaktualnienie dla nowego zlecenia podpietego do pracy
    UPDATE tg_zlecenia SET zl_robocizna=zl_robocizna+NullZero(NEW.pr_koszt) WHERE zl_idzlecenia=NEW.zl_idzlecenia;
   END IF;
  END IF;

  IF (TG_OP = 'DELETE') THEN
    RETURN OLD;
  ELSE
    IF (NEW.zl_idzlecenia>0) THEN
      NEW.ob_idobiektu=(SELECT ob_idobiektu FROM tg_zlecenia WHERE zl_idzlecenia=NEW.zl_idzlecenia);
    END IF;
    RETURN NEW;
  END IF;
END;

 $$;
