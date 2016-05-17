CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _sz_idskladnika ALIAS FOR $1;
 typ ALIAS FOR $2;
 mm RECORD;
 mm2 RECORD;
BEGIN
  SELECT sz_idskladnika, sz_lp, ttw_idtowarusrc, sz_flaga INTO mm FROM tg_skladnikizestawu WHERE sz_idskladnika=_sz_idskladnika;

  IF (typ) THEN
   SELECT sz_idskladnika, sz_lp INTO mm2 FROM tg_skladnikizestawu WHERE (sz_flaga&4)=(mm.sz_flaga&4) AND ttw_idtowarusrc=mm.ttw_idtowarusrc AND sz_lp<mm.sz_lp  ORDER BY sz_lp DESC LIMIT 1 OFFSET 0;
  ELSE
   SELECT sz_idskladnika, sz_lp INTO mm2 FROM tg_skladnikizestawu WHERE (sz_flaga&4)=(mm.sz_flaga&4) AND ttw_idtowarusrc=mm.ttw_idtowarusrc AND sz_lp>mm.sz_lp  ORDER BY sz_lp ASC LIMIT 1 OFFSET 0;
  END IF;

  IF (mm2.sz_idskladnika>0) THEN
  ---znalazlem miejsce do wymiany prorytetami, robie zamiane
   UPDATE tg_skladnikizestawu SET sz_lp=mm2.sz_lp WHERE sz_idskladnika=mm.sz_idskladnika;
   UPDATE tg_skladnikizestawu SET sz_lp=mm.sz_lp WHERE sz_idskladnika=mm2.sz_idskladnika;

   return mm2.sz_idskladnika;
  END IF;
  RETURN 0;
END;
$_$;
