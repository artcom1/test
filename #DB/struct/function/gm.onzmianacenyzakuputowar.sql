CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 i INT;
BEGIN

 IF (NEW.ttw_ostatniadostawa IS NOT NULL) AND ((NEW.ttw_ostcena IS DISTINCT FROM OLD.ttw_ostcena) OR (NEW.ttw_idostwaluty IS DISTINCT FROM OLD.ttw_idostwaluty)) THEN
  FOR i IN array_lower(NEW.ttw_ostatniadostawa,1)..array_upper(NEW.ttw_ostatniadostawa,1)
  LOOP
   IF (NEW.ttw_ostatniadostawa[i] IS NOT NULL) AND ((NEW.ttw_ostcena[i] IS DISTINCT FROM OLD.ttw_ostcena[i]) OR (NEW.ttw_idostwaluty[i] IS DISTINCT FROM OLD.ttw_idostwaluty[i])) THEN
    PERFORM gm.odnotujZmianeCenyZakupu(NEW.ttw_idtowaru,NEW.ttw_ostatniadostawa[i],0::int2,NEW.ttw_ostcena[i],NEW.ttw_idostwaluty[i]);
   END IF;
  END LOOP;
 END IF;

 IF (NEW.ttw_ostatniadostawa IS NOT NULL) AND (NEW.ttw_ostcenanab IS DISTINCT FROM OLD.ttw_ostcenanab) THEN
  FOR i IN array_lower(NEW.ttw_ostatniadostawa,1)..array_upper(NEW.ttw_ostatniadostawa,1)
  LOOP
   IF (NEW.ttw_ostatniadostawa[i] IS NOT NULL) AND (NEW.ttw_ostcenanab[i] IS DISTINCT FROM OLD.ttw_ostcenanab[i]) THEN
    PERFORM gm.odnotujZmianeCenyZakupu(NEW.ttw_idtowaru,NEW.ttw_ostatniadostawa[i],1::int2,NEW.ttw_ostcenanab[i],1);
   END IF;
  END LOOP;
 END IF;
  
 RETURN NEW;
END;
$$;
