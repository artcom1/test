CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 ile INT;
BEGIN

 IF (TG_OP='INSERT') THEN
  UPDATE tg_towary SET ttw_flaga=ttw_flaga|32 WHERE ttw_idtowaru=NEW.ttw_idtowaru AND (ttw_flaga&32)=0;
 END IF;

 IF (TG_OP='DELETE') THEN
  ile=(SELECT count(*) FROM tg_kalkulacje WHERE ttw_idtowaru=OLD.ttw_idtowaru AND kk_idkalk!=OLD.kk_idkalk);
  IF (ile=0) THEN
   UPDATE tg_towary SET ttw_flaga=ttw_flaga&(~32) WHERE ttw_idtowaru=OLD.ttw_idtowaru AND (ttw_flaga&32::int2)=32;
  END IF;
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;

 END IF;
END;
$$;
