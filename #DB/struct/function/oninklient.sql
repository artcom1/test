CREATE FUNCTION oninklient() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF (NEW.k_kod='') THEN
    NEW.k_kod=NEW.k_idklienta::TEXT;
  END IF;
 
  RETURN NEW;
END;
$$;
