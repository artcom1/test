CREATE FUNCTION renumeracjapelementowzestawu() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
 prorytet INT:=1;
 mm RECORD;
 towar INT;
 poczatek BOOL:=false;
 flaga INT;
BEGIN
 FOR mm IN SELECT sz_idskladnika, ttw_idtowarusrc, sz_flaga&4 AS flaga FROM tg_skladnikizestawu  ORDER BY ttw_idtowarusrc ASC, sz_flaga&4 , sz_idskladnika ASC
 LOOP
  IF (poczatek=FALSE) THEN
   towar=mm.ttw_idtowarusrc;
   flaga=mm.flaga;
   poczatek=TRUE;
  END IF;
  IF (towar!=mm.ttw_idtowarusrc OR flaga!=mm.flaga) THEN
   towar=mm.ttw_idtowarusrc;
   flaga=mm.flaga;
   prorytet=1;
  END IF;

  UPDATE tg_skladnikizestawu SET sz_lp=prorytet WHERE sz_idskladnika=mm.sz_idskladnika;
  prorytet=1+prorytet;
 END LOOP;
 RETURN 1;
END;$$;
