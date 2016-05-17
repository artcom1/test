CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 --- Zerowanie stanow i wartosci dla uslugi
 IF (NEW.ttw_usluga=TRUE) THEN
  NEW.ttw_stan=0;
  NEW.ttw_wartosc=0;
  NEW.ttw_cenasr=0;
 END IF;

 IF (NEW.ttw_ostcena=NULL) THEN
  NEW.ttw_ostcena=OLD.ttw_ostcena;
 END IF;
 IF (NEW.ttw_idostwaluty=NULL) THEN
  NEW.ttw_idostwaluty=OLD.ttw_idostwaluty;
 END IF;

 --- Zaokraglenie stanow
 NEW.ttw_stan=round(NEW.ttw_stan,2);

 --- Obliczenie ceny sredniej (w zl)
 IF (NEW.ttw_stan <> 0) THEN
  NEW.ttw_cenasr=round(NEW.ttw_wartosc/(NEW.ttw_stan-NEW.ttw_bilanstk),6);
 END IF;


 --- Flaga ustawiajaca wlasne zmiany
 IF ((NEW.ttw_flaga&16384::int2)<>0) THEN
  NEW.ttw_flaga=NEW.ttw_flaga&(~16384::int2);
  RETURN NEW;
 END IF;

 --- Zwroc wynik
 RETURN NEW;
END;
$$;
