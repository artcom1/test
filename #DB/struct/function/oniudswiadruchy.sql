CREATE FUNCTION oniudswiadruchy() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 ilosc NUMERIC:=0;
 idsw INT;
BEGIN
 IF (TG_OP<>'DELETE') THEN
  ilosc=ilosc+NEW.sr_ilosc;
  idsw=NEW.sw_idswiadectwa;
 END IF;

 IF (TG_OP<>'INSERT') THEN
  ilosc=ilosc-OLD.sr_ilosc;
  idsw=OLD.sw_idswiadectwa;
 END IF;

 IF (ilosc<>0) THEN
  UPDATE tg_swiadectwa SET sw_ilosczafakturowana=sw_ilosczafakturowana+ilosc WHERE sw_idswiadectwa=idsw;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
