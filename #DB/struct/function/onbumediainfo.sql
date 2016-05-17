CREATE FUNCTION onbumediainfo() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
 IF (NEW.mi_ilosczdjec<>OLD.mi_ilosczdjec) THEN
  NEW.mi_zmianazdjec=now();
 END IF;
 RETURN NEW;
END;
$$;
