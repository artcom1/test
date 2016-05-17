CREATE FUNCTION onbiudskladnikizestawu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN 
 IF (TG_OP='INSERT') THEN
  IF ((NEW.sz_flaga&3)!=0) THEN  ---ustawiamy bit odnosnie towarow powiazanych
   NEW.sz_flaga=NEW.sz_flaga|4;
  END IF;
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
