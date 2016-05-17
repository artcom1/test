CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='DELETE') THEN
  UPDATE tg_rozmsppak SET rmp_kodex=gmr.sp_generatekodex(rmp_idsposobu) WHERE rmp_idsposobu=OLD.rmp_idsposobu;
 ELSE
  UPDATE tg_rozmsppak SET rmp_kodex=gmr.sp_generatekodex(rmp_idsposobu) WHERE rmp_idsposobu=NEW.rmp_idsposobu;
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END;
$$;
