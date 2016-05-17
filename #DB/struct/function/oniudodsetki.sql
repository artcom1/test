CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE 
BEGIN
 IF (TG_OP = 'INSERT') THEN
  UPDATE tg_odsetki SET os_datakoncowa=(NEW.os_datapoczatkowa::date-1)::date WHERE os_datakoncowa='2079-11-29';
 END IF;

 IF (TG_OP ='DELETE') THEN
  UPDATE tg_odsetki SET os_datakoncowa='2079-11-29' WHERE os_datakoncowa::date=(OLD.os_datapoczatkowa::date-1)::date;
 END IF;
  
 IF (TG_OP <> 'DELETE') THEN
   return NEW;
 ELSE
   return OLD;
 END IF;
 RETURN OLD;
END;$$;
