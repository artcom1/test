CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 tmp INT:=0;
BEGIN
 IF (TG_OP='INSERT') THEN
 ---sprawdzamy czy dla niektorych powiazan nie przenosic informacji o powiazaniu na glowny rekord np. kwestia rozrachunkow pod windykacje
  IF (NEW.zp_datatype=219 AND NEW.zp_flaga&3=1) THEN
  ---Rozrachunki dla zdarzen windykacyjnyc
   UPDATE kr_rozrachunki SET rr_flaga=rr_flaga|(1<<23) WHERE rr_idrozrachunku=NEW.zp_idref;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  ---sprawdzamy czy dla niektorych powiazan nie ma przenoszenia informacji o powiazaniu na glowny rekord np. kwestia rozrachunkow pod windykacje
  ---jezeli sa to musimy sprawdzic czy nie trzeba tego powiazania usunac
  IF (OLD.zp_datatype=219 AND OLD.zp_flaga&3=1) THEN
  ---Rozrachunki dla zdarzen windykacyjnych
   -----Sprawdzamy czy sa jakies wykonania pod noda operacji
   tmp=(SELECT count(*) FROM tb_zdpowiazania WHERE zp_flaga&3=1 AND zp_idref=OLD.zp_idref  AND zp_datatype=OLD.zp_datatype AND  zp_idpowiazania<>OLD.zp_idpowiazania);
   IF (tmp=0) THEN ---zdejmujemy informacje o zdarzeniu windykacyjnym
    UPDATE kr_rozrachunki SET rr_flaga=rr_flaga&(~(1<<23)) WHERE rr_idrozrachunku=OLD.zp_idref;
   END IF;
  END IF;

  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
