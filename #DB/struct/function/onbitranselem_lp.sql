CREATE FUNCTION onbitranselem_lp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 rec RECORD;
BEGIN
  --- STARTOF: Operacje na LP
 
  IF (NEW.tel_skojzestaw >0) THEN
   --jezeli jestesmy skojarzeni do jakiegos innego rekordu to musimy tam ustawic flage ze ma pozycje powiazane 
   UPDATE tg_transelem SET tel_flaga=tel_flaga|16384, tel_newflaga=tel_newflaga|256 WHERE tel_idelem=NEW.tel_skojzestaw AND tel_newflaga&256=0;
  END IF;
  IF (NEW.tel_skojarzony IS NULL) THEN
   NEW.tel_lpprefix='';
   IF (NEW.tel_skojzestaw >0) THEN
    NEW.tel_lpprefix=(SELECT numerKonta(tel_lpprefix,tel_lp) FROM tg_transelem WHERE tel_idelem=NEW.tel_skojzestaw );
   END IF;
   IF (NEW.tel_flaga&(4096+1024)!=(4096+1024)) THEN ---dla elementow pierwotnych dla ZO/ZW nie zmieniamy numeracji
    NEW.tel_lp=(SELECT nullZero(max(tel_lp))+1 FROM tg_transelem WHERE tr_idtrans=NEW.tr_idtrans AND tel_flaga&1024=NEW.tel_flaga&1024 AND tel_lpprefix=NEW.tel_lpprefix);
   END IF;
  ELSE
   SELECT tel_lp, tel_lpprefix INTO rec FROM tg_transelem WHERE tel_idelem=NEW.tel_skojarzony;
   NEW.tel_lp=rec.tel_lp;
   NEW.tel_lpprefix=rec.tel_lpprefix;
   IF (NEW.tel_lp IS NULL) THEN -- Szukaj drugiego i wez z niego LP
    SELECT tel_lp, tel_lpprefix INTO rec FROM tg_transelem WHERE tel_skojarzony=NEW.tel_skojarzony AND tr_idtrans=NEW.tr_idtrans;
    NEW.tel_lp=rec.tel_lp;
    NEW.tel_lpprefix=rec.tel_lpprefix;
   END IF;
   IF (NEW.tel_lp IS NULL) THEN -- Nadal jest NULL, to normalnie numeroj w takim razie
    NEW.tel_lp=(SELECT nullZero(max(tel_lp))+1 FROM tg_transelem WHERE tel_lpprefix='' AND tr_idtrans=NEW.tr_idtrans AND tel_flaga&1024=NEW.tel_flaga&1024);
    NEW.tel_lpprefix='';
   END IF;
  END IF;
  --- ENDOF: Operacje na LP
  
 RETURN NEW;
END;
$$;
