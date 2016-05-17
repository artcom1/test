CREATE FUNCTION onuceny() RETURNS opaque
    LANGUAGE plpgsql
    AS $$
 DECLARE
  cena numeric;
 BEGIN


  IF (NEW.ttc_auto = TRUE ) THEN
---   RAISE NOTICE 'Nastapila zmiana w Uceny';
   cena=NEW.ttc_cenasp;
   NEW.ttc_cenasp=numeric(round(cena+(cena*NEW.ttc_procent/100),2));
  END IF;

 RETURN NEW;
END;
$$;
