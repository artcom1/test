CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF (TG_OP='UPDATE' OR TG_OP='INSERT') THEN
  IF (NEW.tsp_flaga&2=2) THEN
   UPDATE tr_technostpracy SET tsp_flaga=tsp_flaga&(~2) WHERE tsp_idstanowiska IN (SELECT tsp_idstanowiska FROM tr_technostpracy WHERE the_idelem=NEW.the_idelem AND tsp_idstanowiska<>NEW.tsp_idstanowiska AND tsp_flaga&4=NEW.tsp_flaga&4);
  END IF; 
 END IF; 

 IF (TG_OP='DELETE') THEN
  IF (OLD.tsp_flaga&2=2) THEN
   UPDATE tr_technostpracy SET tsp_flaga=tsp_flaga|2 WHERE tsp_idstanowiska IN (SELECT tsp_idstanowiska FROM tr_technostpracy WHERE the_idelem=OLD.the_idelem AND tsp_idstanowiska<>OLD.tsp_idstanowiska AND tsp_flaga&4=OLD.tsp_flaga&4 ORDER BY tsp_idstanowiska LIMIT 1);
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END
$$;
