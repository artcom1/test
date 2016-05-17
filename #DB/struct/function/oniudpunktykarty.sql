CREATE FUNCTION oniudpunktykarty() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltanew INT:=0;
 deltaold INT:=0;
BEGIN
 
 --Dla OLD
 IF (TG_OP<>'INSERT') THEN
  deltaold=deltaold-OLD.kpt_punktow;
 END IF;

 --Dla NEW
 IF (TG_OP<>'DELETE') THEN
  deltanew=deltanew+NEW.kpt_punktow;
 END IF;

 IF (TG_OP='INSERT') THEN
  UPDATE tg_transakcje SET tr_zamknieta=tr_zamknieta|(1<<15)|16384 WHERE tr_idtrans=NEW.tr_idtrans;
 END IF;

 IF (TG_OP='DELETE') THEN
  UPDATE tg_transakcje SET tr_zamknieta=(tr_zamknieta&(~(1<<15)))|16384 WHERE tr_idtrans=OLD.tr_idtrans;
 END IF;

 --Sprawdz czy sie zmienilo
 IF (TG_OP='UPDATE') THEN
  IF (NEW.kr_idkarty<>OLD.kr_idkarty) THEN
   deltanew=deltanew+deltaold;
   deltaold=0;
  END IF;
 END IF;

 IF (deltaold<>0) THEN
  UPDATE tg_kartypremiowe SET kr_punktow=kr_punktow+deltaold WHERE kr_idkarty=OLD.kr_idkarty;
 END IF;

 IF (deltanew<>0) THEN
  UPDATE tg_kartypremiowe SET kr_punktow=kr_punktow+deltanew WHERE kr_idkarty=NEW.kr_idkarty;
 END IF;
     
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END
$$;
