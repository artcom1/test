CREATE FUNCTION inwwm_checkinwmiejscamagazynowe() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (NEW.mm_vc_sumilosc!=OLD.mm_vc_sumilosc) THEN
  IF (gm.inwwm_ischangemmallowed(NEW.mm_idmiejsca,NEW.mm_openinwscount)=FALSE) THEN
   RAISE EXCEPTION '51|%|Miejsce magazynowe zablokowane przez otwarta inwentaryzacje',NEW.mm_idmiejsca;
  END IF;
 END IF;

 RETURN NEW;
END;
$$;
