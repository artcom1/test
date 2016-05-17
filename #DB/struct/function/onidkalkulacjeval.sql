CREATE FUNCTION onidkalkulacjeval() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 ile INT;
BEGIN

 IF (TG_OP='INSERT') THEN
  IF (NEW.tel_idelem IS NOT NULL) THEN
   UPDATE tg_transelem SET tel_newflaga=tel_newflaga|32 WHERE tel_idelem=NEW.tel_idelem AND (tel_newflaga&32)=0;
   UPDATE tg_kalkulacjeval SET tr_idtrans=(SELECT tr_idtrans FROM tg_transelem WHERE tel_idelem=NEW.tel_idelem) WHERE kv_idwartosci=NEW.kv_idwartosci;
  END IF;
  IF (NEW.pz_idplanu IS NOT NULL) THEN
   UPDATE tg_planzlecenia SET pz_flaga=pz_flaga|32 WHERE pz_idplanu=NEW.pz_idplanu AND (pz_flaga&32)=0;
   UPDATE tg_kalkulacjeval SET zl_idzlecenia=(SELECT zl_idzlecenia FROM tg_planzlecenia WHERE pz_idplanu=NEW.pz_idplanu) WHERE kv_idwartosci=NEW.kv_idwartosci;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  IF (OLD.tel_idelem IS NOT NULL) THEN
   ile=(SELECT count(*) FROM tg_kalkulacjeval WHERE tel_idelem=OLD.tel_idelem AND kv_idwartosci!=OLD.kv_idwartosci);
   IF (ile=0) THEN
    UPDATE tg_transelem SET tel_newflaga=tel_newflaga&(~32) WHERE tel_idelem=OLD.tel_idelem AND (tel_newflaga&32)=32;
   END IF;
  END IF;
  IF (OLD.pz_idplanu IS NOT NULL) THEN
   ile=(SELECT count(*) FROM tg_kalkulacjeval WHERE tel_idelem=OLD.tel_idelem AND kv_idwartosci!=OLD.kv_idwartosci);
   IF (ile=0) THEN
    UPDATE tg_planzlecenia SET pz_flaga=pz_flaga&(~32) WHERE pz_idplanu=OLD.pz_idplanu AND (pz_flaga&32)=32;
   END IF;
  END IF;
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;

 END IF;
END;
$$;
