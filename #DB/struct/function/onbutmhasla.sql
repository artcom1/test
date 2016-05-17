CREATE FUNCTION onbutmhasla() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF OLD.tm_haslo<>NEW.tm_haslo THEN
  NEW.tm_passchanged=now();
 END IF;

 RETURN NEW;
END;
$$;
