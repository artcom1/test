CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 w int:=0;
BEGIN
 IF (TG_OP='INSERT') THEN
  IF (NEW.ob_srcid>0 AND NEW.ob_srctype=17) THEN ---uaktualniamy wartosc pozycji dokumentu ze ma obiekty
   UPDATE tg_transelem SET tel_flaga=tel_flaga|((1<<24)+(1<<16)) WHERE tel_idelem=NEW.ob_srcid;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  IF (OLD.ob_srcid>0 AND OLD.ob_srctype=17) THEN
   w=(SELECT count(*) FROM tg_obiekty WHERE ob_idobiektu!=OLD.ob_idobiektu AND ob_srctype=17 AND ob_srcid=OLD.ob_srcid);
   IF (w=0) THEN
    UPDATE tg_transelem SET tel_flaga=(tel_flaga|(1<<16))&(~(1<<24)) WHERE tel_idelem=OLD.ob_srcid;
   END IF;
  END IF;
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
