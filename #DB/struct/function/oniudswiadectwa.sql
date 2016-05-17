CREATE FUNCTION oniudswiadectwa() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP<>'DELETE') THEN
  IF (NEW.sw_ilosczafakturowana>=NEW.sw_waganetto) THEN
   NEW.sw_flaga=NEW.sw_flaga|2;
  ELSE
   NEW.sw_flaga=NEW.sw_flaga&(~2);
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
