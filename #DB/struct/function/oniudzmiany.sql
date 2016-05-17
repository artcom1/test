CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 roznica INTERVAL;
BEGIN
 
 IF (TG_OP<>'DELETE') THEN
  roznica=(NEW.zm_godzinazak-NEW.zm_godzinaroz)::time;
  NEW.zm_iloscrbh=date_part('hours',roznica)+date_part('minute',roznica)/60;
  NEW.zm_iloscrbh=abs(NEW.zm_iloscrbh);
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
