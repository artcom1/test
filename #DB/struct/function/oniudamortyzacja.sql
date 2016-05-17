CREATE FUNCTION oniudamortyzacja() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 dnetto NUMERIC:=0;
 dnettokoszt NUMERIC:=0;
 plan RECORD;
BEGIN
 IF (TG_OP='UPDATE') THEN
   IF (OLD.st_id<>NEW.st_id) THEN
    RAISE EXCEPTION 'Nie mozna zmienic srodka trwalego w amortyzacji';
   END IF;
 END IF;
 IF (TG_OP <> 'INSERT') THEN
   dnetto=-OLD.am_wartam;
   dnettokoszt=-OLD.am_wartamkoszt;
 END IF;

 IF (TG_OP ='DELETE') THEN
  UPDATE  st_srodkitrwale SET str_wartumoz=str_wartumoz+dnetto, str_wartumozkoszt=str_wartumozkoszt+dnettokoszt WHERE str_id=OLD.st_id;   
  UPDATE st_planst SET am_id=NULL WHERE am_id=OLD.am_id;
  dnetto=0;
  dnettokoszt=0;
 END IF;
 
 IF (TG_OP <>'DELETE') THEN
  dnetto=dnetto+NEW.am_wartam;
  dnettokoszt=dnettokoszt+NEW.am_wartamkoszt;

  IF (dnetto <> '0' ) THEN
    UPDATE  st_srodkitrwale SET str_wartumoz=dnetto+str_wartumoz WHERE str_id=NEW.st_id;   
  END IF;

  IF (dnettokoszt <> '0' ) THEN
    UPDATE  st_srodkitrwale SET  str_wartumozkoszt=dnettokoszt+str_wartumozkoszt WHERE str_id=NEW.st_id;   
  END IF;

 IF (NEW.pl_idplanu> 0 ) THEN
   UPDATE st_planst SET am_id=NEW.am_id WHERE pl_idplanu=NEW.pl_idplanu;
  END IF;
  
 END IF;
 
 IF (TG_OP <> 'DELETE') THEN
   return NEW;
 ELSE
   return OLD;
 END IF ;
 RETURN OLD;
END;
  $$;
