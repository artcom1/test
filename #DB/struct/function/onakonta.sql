CREATE FUNCTION onakonta() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 rec RECORD;
BEGIN

 IF (
     (OLD.kt_prefix<>NEW.kt_prefix) OR 
     (OLD.kt_numer<>NEW.kt_numer) OR 
     (NEW.kt_poziom<>OLD.kt_poziom) OR 
     (NEW.kt_zerosto<>OLD.kt_zerosto) OR 
     ((NEW.ktt_idtypu IS NULL)<>(OLD.ktt_idtypu IS NULL)) OR
     ((NEW.ktt_idtypuinh IS NULL)<>(OLD.ktt_idtypuinh IS NULL))
    ) 
 THEN
  --- Zrob update zaleznych prefixow
  UPDATE kh_konta SET kt_prefix=numerKonta(NEW.kt_prefix,NEW.kt_numer,NEW.kt_zerosto),
                      kt_poziom=NEW.kt_poziom+1,
		      ktt_idtypuinh=COALESCE(NEW.ktt_idtypuinh,NEW.ktt_idtypu),
		      kt_zerosto=(kt_zerosto&(~752))|
			             ((NEW.kt_zerosto&15)<<4) |
						 ((NEW.kt_zerosto&256)<<1)
		      WHERE kt_ref=NEW.kt_idkonta;
 END IF;
 
 RETURN NEW;
END;$$;
