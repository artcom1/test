CREATE FUNCTION aoniudplanst() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
  IF (TG_OP = 'UPDATE' OR TG_OP = 'DELETE') THEN
  ---zmiejszamy planowana amortyzacje na srodkach trwalych
     UPDATE st_srodkitrwale SET str_wartoscplanu=str_wartoscplanu-OLD.pl_wartosc,str_wartoscplanukoszt=str_wartoscplanukoszt-OLD.pl_wartosckoszt WHERE str_id=OLD.str_id;
  END IF;
  IF (TG_OP = 'UPDATE' OR TG_OP = 'INSERT') THEN
  ---zwiekszamy planowana amortyzacje na srodkach trwalych
     UPDATE st_srodkitrwale SET str_wartoscplanu=str_wartoscplanu+NEW.pl_wartosc,str_wartoscplanukoszt=str_wartoscplanukoszt+NEW.pl_wartosckoszt WHERE str_id=NEW.str_id;
  END IF;

  IF (TG_OP = 'UPDATE') THEN
    IF (NEW.str_id<>OLD.str_id) THEN
       PERFORM przeliczPlanST(OLD.str_id, OLD.nm_miesiac);
       PERFORM przeliczPlanST(NEW.str_id, NEW.nm_miesiac);
    ELSE 
      IF (NEW.pl_wartosc<>OLD.pl_wartosc OR NEW.pl_wartosckoszt<>OLD.pl_wartosckoszt) THEN
       ---dla roznych miesiecy dokonujemy przeliczenia wszystkich planow
        IF (NEW.nm_miesiac=OLD.nm_miesiac) THEN
          ---zmiejszamy wartosci bierzace na pozniejszych planach o roznice zmiany wartosci na przerabianym planie
          UPDATE st_planst SET pl_wartoscbiez=pl_wartoscbiez-(NEW.pl_wartosc-OLD.pl_wartosc), pl_wartoscbiezkoszt=pl_wartoscbiezkoszt-(NEW.pl_wartosckoszt-OLD.pl_wartosckoszt) WHERE str_id=NEW.str_id AND nm_miesiac>=NEW.nm_miesiac;
          DELETE FROM st_planst WHERE str_id=NEW.str_id AND pl_wartoscbiez<0 AND pl_wartosc<=abs(pl_wartoscbiez) AND pl_wartoscbiezkoszt<0 AND pl_wartosckoszt<=abs(pl_wartoscbiezkoszt);
          UPDATE st_planst SET pl_wartosc=0 WHERE str_id=NEW.str_id AND pl_wartoscbiez<0 AND pl_wartosc<=abs(pl_wartoscbiez);
	  UPDATE st_planst SET pl_wartosckoszt=0 WHERE str_id=NEW.str_id AND pl_wartoscbiezkoszt<0 AND pl_wartosckoszt<=abs(pl_wartoscbiezkoszt);
          UPDATE st_planst SET pl_wartosc=pl_wartosc-abs(pl_wartoscbiez) WHERE str_id=NEW.str_id AND pl_wartoscbiez<0 AND pl_wartosc>abs(pl_wartoscbiez);
	  UPDATE st_planst SET pl_wartosckoszt=pl_wartosckoszt-abs(pl_wartoscbiezkoszt) WHERE str_id=NEW.str_id AND pl_wartoscbiezkoszt<0 AND pl_wartosckoszt>abs(pl_wartoscbiezkoszt);
        ELSE
          PERFORM przeliczPlanST(NEW.str_id, min(NEW.nm_miesiac, OLD.nm_miesiac)::int);
        END IF;
      ELSE
      ---sprawdzamy czy sa rozne miesiace jesli tak to dokonujemy przeliczenia planow
        IF (NEW.nm_miesiac<>OLD.nm_miesiac) THEN
          PERFORM przeliczPlanST(NEW.str_id, min(NEW.nm_miesiac, OLD.nm_miesiac)::int);
        END IF;
      END IF;
    END IF;			
  END IF;

  IF (TG_OP = 'INSERT') THEN
     PERFORM przeliczPlanST(NEW.str_id,NEW.nm_miesiac);
  END IF;

  IF (TG_OP = 'DELETE') THEN
     PERFORM przeliczPlanST(OLD.str_id::int, OLD.nm_miesiac);    
    RETURN OLD;
  END IF;
 
  RETURN NEW;
END;
 $$;
