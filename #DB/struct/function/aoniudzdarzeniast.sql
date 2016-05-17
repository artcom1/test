CREATE FUNCTION aoniudzdarzeniast() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
 IF (TG_OP = 'UPDATE' OR TG_OP = 'DELETE') THEN
  ---zmiejszamy planowana amortyzacje na srodkach trwalych
  UPDATE st_srodkitrwale SET str_wartosczdarzen=str_wartosczdarzen-OLD.zd_zwiekszenie, str_wartosczdarzenkoszt=str_wartosczdarzenkoszt-OLD.zd_zwiekszeniekoszt WHERE str_id=OLD.str_id;
 END IF;
 IF (TG_OP = 'UPDATE' OR TG_OP = 'INSERT') THEN
  ---zwiekszamy planowana amortyzacje na srodkach trwalych
  UPDATE st_srodkitrwale SET str_wartosczdarzen=str_wartosczdarzen+NEW.zd_zwiekszenie, str_wartosczdarzenkoszt=str_wartosczdarzenkoszt+NEW.zd_zwiekszeniekoszt WHERE str_id=NEW.str_id;
 END IF;


 IF (TG_OP = 'DELETE') THEN
  PERFORM przeliczPlanST(OLD.str_id::int,OLD.nm_miesiac);  
  RETURN OLD;
 END IF;
 IF (TG_OP = 'UPDATE') THEN 
  PERFORM przeliczPlanST(NEW.str_id::int,min(NEW.nm_miesiac, OLD.nm_miesiac)::int);   
 ELSE
  PERFORM przeliczPlanST(NEW.str_id::int,NEW.nm_miesiac::int);   
 END IF;
 RETURN NEW;
END;
  $$;
