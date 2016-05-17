CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
 
 IF (TG_OP<>'DELETE') THEN
  IF (NEW.tr_idtrans=NULL AND NEW.kwh_idheadu=NULL) THEN
   RAISE EXCEPTION 'Musi byc ustalony jakis dokument';
  END IF;
 END IF;
 IF (TG_OP='UPDATE') THEN

  --Nie pozwol na zmiane wartosci przenoszonych wynagrodzen
  IF (((NEW.wnd_flaga&1)=1) AND (NEW.wg_idwynagrodzenia IS NOT NULL)) THEN
   RAISE EXCEPTION '14|%:%:%|Wynagrodzenie jest juz przeniesione!',NEW.wnd_idwynagrodzenia,NEW.tr_idtrans,NEW.kwh_idheadu,NEW.wnd_hashcode;
  END IF;
  
  --Nie mozna bezposrednio przenosic z wynagrodzenia na wynagrodzenie
  IF ( (NEW.wg_idwynagrodzenia IS NOT NULL) AND (OLD.wg_idwynagrodzenia IS NOT NULL) AND (NEW.wg_idwynagrodzenia<>OLD.wg_idwynagrodzenia) ) THEN
   RAISE EXCEPTION '14|%:%:%|Wynagrodzenie jest juz przeniesione!',NEW.wnd_idwynagrodzenia,NEW.tr_idtrans,NEW.kwh_idheadu,NEW.wnd_hashcode;
  END IF;

  --Blokada duplikatow
  IF ((NEW.wnd_flaga&2)=2) THEN
   IF (NEW.wg_idwynagrodzenia IS NOT NULL) THEN
    NEW.wnd_bduplicate=NULL;
   ELSE
    NEW.wnd_bduplicate=1;
   END IF;
  ELSE
   NEW.wnd_bduplicate=1;
  END IF;

  NEW.wnd_flaga=NEW.wnd_flaga&(~1);
 END IF;

 IF (TG_OP='DELETE') THEN
  IF (OLD.wg_idwynagrodzenia IS NOT NULL) THEN
   RAISE EXCEPTION '14|%:%:%|Wynagrodzenie jest juz przeniesione!',OLD.wnd_idwynagrodzenia,OLD.tr_idtrans,OLD.wnd_hashcode;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END
$$;
