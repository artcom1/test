CREATE FUNCTION onbdzdarzenia_gsr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
	
 IF ((TG_OP!='DELETE') AND (shouldEscapeZdarzeniaTriggers()=TRUE)) THEN
  RETURN NEW;
 END IF;
	
	
 INSERT INTO tb_googlesynchronize_remove(gga_id, gsr_calendarid, gsr_eventid)
 SELECT s.gga_id, s.ggs_calendarid, s.ggs_eventid
 FROM tb_googlesynchronize AS s		 
 WHERE s.zd_idzdarzenia = OLD.zd_idzdarzenia AND s.gga_id IS NOT NULL;
	  
 RETURN OLD;
END;
$$;
