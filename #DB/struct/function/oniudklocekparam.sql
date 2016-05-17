CREATE FUNCTION oniudklocekparam() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='INSERT') THEN
  NEW.fr_idraportu=(SELECT fr_idraportu FROM tf_raportklocki WHERE fk_idklocka=NEW.fk_idklocka);
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
