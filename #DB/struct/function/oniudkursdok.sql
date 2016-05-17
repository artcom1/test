CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 ile INT:=0;
BEGIN

 IF (TG_OP='INSERT') THEN
  UPDATE tg_transakcje SET tr_zamknieta=tr_zamknieta|(1<<16) WHERE tr_idtrans=NEW.tr_idtrans AND tr_zamknieta&(1<<16)=0;
 END IF;


 IF (TG_OP='DELETE') THEN
  ile=(SELECT count(*) FROM tg_kursdok WHERE tr_idtrans=OLD.tr_idtrans AND kd_idkursu<>OLD.kd_idkursu);
  IF (ile=0) THEN
   UPDATE tg_transakcje SET tr_zamknieta=tr_zamknieta&(~(1<<16)) WHERE tr_idtrans=OLD.tr_idtrans AND tr_zamknieta&(1<<16)=(1<<16);
  END IF;
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END
$$;
