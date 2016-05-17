CREATE FUNCTION oniudtowary() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='INSERT') THEN
   IF (NEW.ttw_klucz='') THEN
    NEW.ttw_klucz=NEW.ttw_idtowaru::TEXT;
  END IF;
 END IF; 

 IF (TG_OP<>'DELETE') THEN
  NEW.ttw_klucz=upper(NEW.ttw_klucz);

   --- Zaokraglenie stanow
  NEW.ttw_stan=array_round(NEW.ttw_stan,4);

  --- Zerowanie stanow i wartosci dla uslugi
  IF (NEW.ttw_usluga=TRUE) AND (NEW.ttw_rtowaru NOT IN (128,256)) THEN
   NEW.ttw_stan=array_ustaw_wartosc(NEW.ttw_stan,0);
   NEW.ttw_wartosc=array_ustaw_wartosc(NEW.ttw_wartosc,0);
   NEW.ttw_cenasr=array_ustaw_wartosc(NEW.ttw_cenasr,0);
  ELSE
   --- Obliczenie ceny sredniej (w zl)
   NEW.ttw_cenasr=array_round(array_div(NEW.ttw_wartosc,array_minus(NEW.ttw_stan,NEW.ttw_bilanstk)),2);
  END IF;

  --- Flaga ustawiajaca wlasne zmiany
  IF ((NEW.ttw_flaga&16384)<>0) THEN
   NEW.ttw_flaga=NEW.ttw_flaga&(~16384);
   RETURN NEW;
  END IF;
 END IF;
 
 -------------------------------------------------------------- 
 --- WYMIARY
 IF (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
 
  IF (COALESCE(NEW.ttw_dlugosc_m,0)=0) THEN
   NEW.ttw_dlugosc_m=1;
  END IF;
  IF (COALESCE(NEW.ttw_powierzchnia_m,0)=0) THEN
   NEW.ttw_powierzchnia_m=1;
  END IF;
  IF (COALESCE(NEW.ttw_objetosc_m,0)=0) THEN
   NEW.ttw_objetosc_m=1;
  END IF;

  NEW.ttw_dlugosc_mpq = COALESCE(NEW.ttw_dlugosc_l::mpq/NEW.ttw_dlugosc_m,0);
  NEW.ttw_powierzchnia_mpq = COALESCE(NEW.ttw_powierzchnia_l::mpq/NEW.ttw_powierzchnia_m,0);
  NEW.ttw_objetosc_mpq = COALESCE(NEW.ttw_objetosc_l::mpq/NEW.ttw_objetosc_m,0);
 END IF; 
 --------------------------------------------------------------

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
