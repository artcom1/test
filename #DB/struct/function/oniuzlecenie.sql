CREATE FUNCTION oniuzlecenie() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

 IF (TG_OP='UPDATE') THEN
   IF (OLD.ob_idobiektu<>NEW.ob_idobiektu) THEN
     UPDATE tg_prace SET ob_idobiektu=NEW.ob_idobiektu WHERE zl_idzlecenia=NEW.zl_idzlecenia;
   END IF;
 END IF;

 RETURN NEW;

END;

$$;
